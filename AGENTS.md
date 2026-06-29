## Overview

PlaceStory는 장소 기록 iOS 앱으로, **RIBs (Router-Interactor-Builder) 패턴** + **Clean Architecture**를 기반으로 한 멀티 모듈 Swift Package 구조로 구성되어 있다.

- 최소 지원 버전: iOS 17
- 언어: Swift 5.9+
- UI 프레임워크: UIKit (SwiftUI 미사용)

## 빌드 및 테스트

### Build & Test Tools (XcodeBuildMCP)

raw xcodebuild 명령어 대신 MCP 도구를 우선 사용한다:

- **Build**: `build_sim` / `build_device` — 구조화된 에러 출력
- **Test**: `test_sim` / `test_device` — pass/fail 결과 확인
- **Simulators**: `list_sims`, `boot_sim`, `open_sim`
- **Debug**: `debug_attach_sim`, `debug_stack`, `debug_variables`

### Apple Xcode MCP (mcpbridge)

- **Documentation**: Apple 문서 검색에는 `DocumentationSearch` 사용
- **Swift REPL**: API 검증에는 `ExecuteSnippet` 사용
- **Previews**: SwiftUI 헤드리스 렌더링에는 `RenderPreview` 사용

Apple API 질문에는 WebSearch 대신, REPL 작업에는 Bash `swift` 대신 이 도구들을 우선 사용한다.

### xcodebuild 직접 사용 (MCP 도구를 쓸 수 없는 경우)

```bash
# 빌드
xcodebuild -project PlaceStory/PlaceStory.xcodeproj -scheme PlaceStory -configuration Debug build

# 테스트 (전체)
xcodebuild -project PlaceStory/PlaceStory.xcodeproj -scheme PlaceStory -destination 'platform=iOS Simulator,name=iPhone 16' test

# 특정 테스트 파일 실행
xcodebuild -project PlaceStory/PlaceStory.xcodeproj -scheme PlaceStory -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:PlaceStoryTests/TargetTestClass test
```

**Fastlane 배포:**
```bash
cd PlaceStory
bundle exec fastlane upload_testflight   # TestFlight 배포
bundle exec fastlane upload_appstore     # App Store 배포
bundle exec fastlane install_match       # 서명 인증서 설치
```

## 아키텍처

### 레이어 구조

```
Domain          ← 비즈니스 로직 (UseCase, Entity, Repository 프로토콜)
Platform        ← 인프라 구현체 (RealmDB, Keychain, AppleMapView, Repository 구현)
Feature Modules ← 화면별 RIBs (LoggedOut, LoggedIn, MyLocation, PlaceDiary 등)
ProxyPackage    ← 공통 의존성 재exports, CommonUI, Utils
AppRoot         ← 앱 진입점 및 루트 라우팅
```

### RIBs 패턴

각 피처 모듈은 다음 5개 컴포넌트로 구성된다:

- **Builder** — 의존성 주입 및 RIB 생성 팩토리
- **Router** — 자식 RIB 부착/분리 및 네비게이션
- **Interactor** — 비즈니스 로직 및 상태 관리 (Combine 사용)
- **ViewController** — UI 표시 (UIKit)
- **Dependency 프로토콜** — 인터페이스 분리를 통한 의존성 주입

부모-자식 RIB 간 통신은 **Listener 프로토콜**을 통해 이루어진다 (자식 → 부모 방향).

### 의존성 주입

루트는 `AppComponent` (SceneDelegate에서 생성). 각 Builder는 자신에게 필요한 의존성을 Dependency 프로토콜로 선언하고, 부모 Component에서 주입받는다.

```
SceneDelegate → AppComponent → AppRootBuilder → ...하위 RIBs
```

### 데이터 흐름 (UseCase 패턴)

```
ViewController (이벤트 전달)
  → Interactor (로직 처리, Combine)
    → UseCase (도메인 규칙, AnyPublisher<T, Error> 반환)
      → Repository 프로토콜 (Domain 레이어)
        → RepositoryImp 구현체 (Platform 레이어)
          → RealmDatabaseImp / KeychainServiceImp
```

## 주요 모듈 구조

```
PlaceStory/
├── AppRoot/          # 앱 루트, 인증 상태에 따라 LoggedOut/LoggedIn 라우팅
├── Domain/           # 엔티티, UseCase 프로토콜, Repository 프로토콜
├── Platform/         # Realm DB, Keychain, AppleMapView, Repository 구현체
├── ProxyPackage/     # 외부 의존성 재export + CommonUI + Utils
├── LoggedOut/        # Apple 로그인 화면
├── LoggedIn/         # 탭 기반 메인 화면 (MyLocation, PlaceDiary 포함)
├── MyLocation/       # 지도 + PlaceSearcher (장소 검색)
├── PlaceDiary/       # 장소 기록 목록 + PlaceList + PlaceRecordEditor
└── PlaceStory/       # 앱 타겟 (AppDelegate, SceneDelegate, AppComponent, Assets)
```

## 핵심 의존성

| 라이브러리 | 용도 |
|---|---|
| **ModernRIBs** | RIBs 아키텍처 프레임워크 |
| **SnapKit** | AutoLayout DSL |
| **Realm** | 로컬 데이터베이스 (장소 기록 저장) |
| **Firebase** (Auth, Firestore, Database, Analytics) | Apple Sign-In 연동, 백엔드 |

## 주요 도메인 엔티티

- `PlaceRecord` — 장소 기록 (제목, 설명, 카테고리, 날짜, 이미지)
- `PlaceMark` — 지도 좌표 + 장소명
- `AppleUser` — 로그인 사용자 정보

## 로컬 DB (Realm)

`RealmDatabaseImp`가 모든 Realm CRUD를 담당한다. 스키마 변경 시 `RealmMigrationManager`에 마이그레이션 버전을 추가해야 한다. 각 레코드는 `userId`와 `placeName`으로 조회한다.

## 새 피처 모듈 추가 방법

1. Swift Package로 새 모듈 생성 후 `Package.swift`에 product/target 선언
2. 의존성 모듈(Domain, ProxyPackage 등)을 해당 Package.swift에 명시
3. Builder/Router/Interactor/ViewController 파일 생성
4. 부모 RIB의 Router에 attach/detach 로직 추가
5. `AppRoot/Package.swift` 또는 부모 모듈의 의존성에 새 모듈 추가
