# MY RECORD — GitHub + Cloudflare Pages 배포

## 프로젝트 파일
- `index.html`: MY RECORD 웹 앱
- `supabase-setup.sql`: 회원별 데이터베이스와 비공개 파일 저장소 설정

## A. Supabase 연결 (회원가입·로그인·파일 보관)
1. Supabase에서 새 프로젝트를 만듭니다.
2. SQL Editor에서 `supabase-setup.sql` 전체를 실행합니다.
3. Project Settings → API에서 Project URL과 anon/public key를 확인합니다.
4. `index.html` 아래쪽의 다음 값을 본인 프로젝트 값으로 바꿉니다.
   - `YOUR_SUPABASE_URL`
   - `YOUR_SUPABASE_ANON_KEY`
5. `service_role` 키는 절대 사용하거나 공개하지 마세요.
6. Authentication 설정에서 이메일 인증 및 비밀번호 복구 정책을 확인합니다.

## B. GitHub에 올리기
1. GitHub에서 새 저장소(repository)를 만듭니다. 예: `my-record`
2. 저장소는 코드 공개 여부에 맞춰 Public 또는 Private로 선택합니다. 생기부 원본이나 개인정보 파일은 저장소에 올리지 마세요.
3. 이 프로젝트 폴더 안의 `index.html`과 `supabase-setup.sql`을 저장소 최상위(root)에 업로드하고 Commit 합니다.
4. `index.html`이 저장소 최상위에 있어야 합니다.

## C. Cloudflare Pages 배포
1. Cloudflare 대시보드에서 Workers & Pages로 이동합니다.
2. Create application → Pages → Connect to Git을 선택합니다.
3. GitHub를 연결하고 방금 만든 `my-record` 저장소를 선택합니다.
4. 빌드 설정:
   - Production branch: `main`
   - Framework preset: None
   - Build command: 비워 두거나 `exit 0`
   - Build output directory: `/` 또는 `.` (대시보드에서 허용하는 저장소 루트 값)
5. Save and Deploy를 누릅니다.
6. 배포가 끝나면 `https://프로젝트이름.pages.dev` 주소가 생성됩니다.
7. 코드를 GitHub의 main 브랜치에 업데이트하면 Cloudflare Pages가 자동으로 다시 배포합니다.

## D. Supabase 인증 URL 설정
배포된 `https://프로젝트이름.pages.dev` 주소를 Supabase Authentication → URL Configuration의 Site URL과 Redirect URLs에 등록합니다.

## 보안·테스트
- 생기부 원본 PDF, 학생 이름/학교/학번 등의 개인정보를 GitHub 저장소에 올리지 마세요.
- 파일은 Supabase의 비공개 `private-records` 버킷에 저장되며, 테이블과 Storage에 사용자별 RLS 정책을 적용합니다.
- 공개하기 전에 테스트 계정 두 개를 만들어 서로의 자료를 조회·열기·삭제할 수 없는지 확인하세요.
- anon/public 키는 브라우저에 쓰는 공개 키입니다. service_role 키는 프런트엔드에 절대 넣지 마세요.
- 이 프로젝트는 정적 프런트엔드 + Supabase 인증/DB/스토리지 구조입니다.
