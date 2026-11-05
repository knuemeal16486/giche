# 모든 입자 · 기체의 압력, 부피, 온도

중학교 과학 1 ‘(6) 기체의 성질’ 수업용 인터랙티브 레슨입니다.

- 수업 주소: https://knuemeal16486.github.io/giche/
- 펼침면 바로가기: `#pressure` `#gas` `#squeeze` `#pvlab` `#boyle` `#warm` `#check` `#words` `#teachers`
- 학생은 태블릿, 교사는 전자칠판(1500px 이상에서 큰 글씨)으로 쓰도록 만들었습니다.
- 도장은 각 기기의 브라우저에만 저장되고, 실험 기록표는 페이지를 닫으면 사라집니다.

구성 형식은 Techartist의 [Every Joule · Lesson 1](https://iamtechartist.github.io/every-joule-lesson1/)을 따랐습니다.

## 오프라인 사용

- 기기에서 페이지를 **와이파이가 될 때 한 번** 열어 두면, 그다음부터는 인터넷이 끊겨도 열립니다(`sw.js`).
- 수업 전에 모든 태블릿에서 한 번씩 열어 두세요. 비행기 모드로 켜서 열리면 준비 완료입니다.
- `index.html`을 고쳐 올리면 학생 기기에는 **다음 번 열 때** 반영됩니다(캐시를 먼저 보여주고 뒤에서 새로 받음).
- 글꼴은 Google Fonts 대신 `fonts/`에 직접 담았고, 페이지에 쓰인 글자만 남겼습니다. 새 글자를 추가하면 `tools/subset-fonts.sh`를 실행하고 `sw.js`의 `VERSION`을 올리세요. 실행하지 않아도 새 글자는 기본 글꼴로 보일 뿐 깨지지는 않습니다.
