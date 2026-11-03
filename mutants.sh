#!/usr/bin/env bash
# Хэсэг B: 3 мутантыг автоматаар ажиллуулж results/ руу хадгална.
# Ажиллуулах: bash mutants.sh   (төслийн үндсэн хавтаснаас, mvn суусан байх ёстой)
F=src/main/java/mn/edu/must/sqat/CourseRegistrationService.java
cp "$F" /tmp/CourseRegistrationService.orig
mkdir -p results
restore() { cp /tmp/CourseRegistrationService.orig "$F"; }
trap restore EXIT

perl -0pi -e 's|^(\s*)(if \(!student\.active\(\)\) return "ERROR_INACTIVE_STUDENT";)|$1// $2|m' "$F"
mvn test 2>&1 | tee results/mvn-test-mutant-1.txt; restore

perl -0pi -e 's|^(\s*)(repository\.saveRegistration\(studentId, courseId\);)|$1// $2|m' "$F"
mvn test 2>&1 | tee results/mvn-test-mutant-2.txt; restore

perl -0pi -e 's/studentId == null \|\| courseId == null/studentId == null/' "$F"
mvn test 2>&1 | tee results/mvn-test-mutant-3.txt; restore

mvn test 2>&1 | tee results/mvn-test.txt
grep -E "Tests run:.*Fail|BUILD" results/mvn-test*.txt | grep -v "Time elapsed"
