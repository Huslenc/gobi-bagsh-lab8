# Лаборатори №8 — Mock объектууд (Mockito)

**Оюутан:** О.Хүслэн — **Код:** B242270073

## Орчин
```
openjdk version "21.0.13" 2026-10-20
OpenJDK Runtime Environment (build 21.0.13+9-1-deb13u2-Debian)
OpenJDK 64-Bit Server VM (build 21.0.13+9-1-deb13u2-Debian, mixed mode, sharing)

Apache Maven 3.9.9
Maven home: /usr/share/maven
Java version: 21.0.13, vendor: Debian, runtime: /usr/lib/jvm/java-21-openjdk-amd64
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "6.12.113+deb13-amd64", arch: "amd64", family: "unix"

```

## Тестийн тоо
`results/mvn-test.txt`-ийн сүүлийн мөр: **Tests run: 10, Failures: 0, Errors: 0, Skipped: 0** (7 энгийн + A8-ийн 3 мөр).

## A8 дахь lenient()
A8-д мөр бүр өөр сценари тул зарим stub ашиглагдахгүй (жишээ нь оюутан олдоогүй мөрд `courseExists`/`prerequisites` руу хүрдэггүй).
MockitoExtension-ий strict stubs ийм stub-д UnnecessaryStubbingException өгдөг тул `lenient().when(...)` ашигласан.

## Хэсэг B — мутацийн хүснэгт
| № | Эвдрэл | Унасан тест(үүд) | Failures/Errors |
|---|--------|------------------|-----------------|
| 1 | `if (!student.active())` комментлосон | A3 `register_inactiveStudent_...`, A8 (inactive мөр) | 2 |
| 2 | `saveRegistration(...)` комментлосон | A1 `register_activeStudentWithPrerequisites_...`, A5 `register_emailSenderThrows_...` | 2 |
| 3 | `\|\| courseId == null` устгасан | A6 `register_nullArguments_...` | 1 |

Мутант 3: A6 тестийг анхнаасаа `studentId` ба `courseId` аргумент бүрийг тусад нь null болгож (`register(null, COURSE_ID)`, `register(STUDENT_ID, null)`, мөн хоёуланг нь null) шалгахаар бичсэн. Иймээс `|| courseId == null` нөхцлийг устгахад `register(STUDENT_ID, null)` дуудалт IllegalArgumentException шидэхгүй болж, тест унаж мутантыг барьсан (Failures: 1, `results/mvn-test-mutant-3.txt`). Хэрвээ зөвхөн `register(null, null)` гэж шалгасан бол `studentId == null` үлдсэн тул мутант баригдахгүй байх байсан. Мутантыг барьсан тул тестэд нэмэлт засвар хийх шаардлагагүй болсон.

## Дүгнэлт
Mock объект нь гадны хамаарлуудыг (өгөгдлийн сан, и-мэйл сервер гэх мэт) программ дотор бүрэн орлож, бизнес логикийг тусгаарласан нэгжийн түвшинд хурдан шалгах боломжийг олгодог. Харин гараар бичсэн fake объект нь бодит ажиллагааг дуурайхын тулд нэмэлт төвөгтэй хэрэгжүүлэлт шаарддаг тул хөгжүүлэлтийн явцыг удаашруулдаг. Тиймээс стандарт сангийн энгийн классууд, өгөгдөл тээгч объект болон гадны төвөгтэй хамааралгүй энгийн логикийг mock хийх шаардлагагүй юм. Хэрэв verify аргуудыг хэтрүүлэн олон ашиглавал тестийн код өөрчлөлтөд хэт мэдрэг болж, шаардлагагүйгээр унах эрсдэлтэй. Тиймээс тестийг зохион байгуулахдаа хэт нарийн деталиудыг бус, системийн чухал үр дүнгүүдийг үнэн зөв баталгаажуулахад анхаарах хэрэгтэй. Мутацийн туршилтаар кодын зориудаар гаргасан эвдрэлүүдийг тестүүд маань алдалгүй барьж чадаж байгаа нь тестийн багц найдвартай ажиллаж буйн баталгаа боллоо.
