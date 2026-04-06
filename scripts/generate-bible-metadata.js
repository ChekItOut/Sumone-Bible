/**
 * 성경 메타데이터 생성 스크립트
 *
 * assets/data/bible.json에서 다음 정보를 추출하여 TypeScript 파일 생성:
 * 1. 66권 성경 순서 배열 (BIBLE_BOOKS)
 * 2. 책별 최대 장 수 (BOOK_METADATA)
 * 3. 장별 최대 절 수 (CHAPTER_VERSES)
 *
 * 실행: node scripts/generate-bible-metadata.js
 */

const fs = require('fs');
const path = require('path');

// 경로 설정
const bibleJsonPath = path.join(__dirname, '../assets/data/bible.json');
const outputPath = path.join(__dirname, '../supabase/functions/generate-daily-verse/bible-metadata.ts');

console.log('📖 성경 메타데이터 생성 시작...');
console.log(`   입력: ${bibleJsonPath}`);
console.log(`   출력: ${outputPath}`);

// 1. bible.json 읽기
let bibleData;
try {
  const bibleJson = fs.readFileSync(bibleJsonPath, 'utf8');
  bibleData = JSON.parse(bibleJson);
  console.log(`✅ bible.json 로드 완료: ${Object.keys(bibleData).length}개 구절`);
} catch (error) {
  console.error('❌ bible.json 읽기 실패:', error.message);
  process.exit(1);
}

// 2. 성경 데이터 파싱
const books = [];
const bookSet = new Set();
const chapterVerses = {};

for (const key in bibleData) {
  // 키 형식: "창1:1", "요3:16", "계22:21"
  const match = key.match(/^(.+?)(\d+):(\d+)$/);

  if (match) {
    const book = match[1];
    const chapter = parseInt(match[2], 10);
    const verse = parseInt(match[3], 10);

    // 책 순서 보존 (첫 등장 순서)
    if (!bookSet.has(book)) {
      books.push(book);
      bookSet.add(book);
    }

    // 장별 최대 절 수 계산
    if (!chapterVerses[book]) {
      chapterVerses[book] = {};
    }
    if (!chapterVerses[book][chapter]) {
      chapterVerses[book][chapter] = 0;
    }
    chapterVerses[book][chapter] = Math.max(chapterVerses[book][chapter], verse);
  }
}

console.log(`✅ 파싱 완료: ${books.length}권 성경`);

// 3. 책별 최대 장 수 계산
const bookMetadata = {};
for (const book in chapterVerses) {
  const chapters = Object.keys(chapterVerses[book]).map(Number);
  bookMetadata[book] = {
    chapters: Math.max(...chapters)
  };
}

// 4. TypeScript 파일 생성
const tsContent = `/**
 * 성경 메타데이터
 *
 * 이 파일은 scripts/generate-bible-metadata.js로 자동 생성되었습니다.
 * 수동으로 수정하지 마세요!
 *
 * 생성일: ${new Date().toISOString()}
 * 총 ${books.length}권 성경
 */

/**
 * 66권 성경 순서 배열
 */
export const BIBLE_BOOKS: string[] = ${JSON.stringify(books, null, 2)};

/**
 * 책별 최대 장 수
 * 예: { "창": { chapters: 50 }, "출": { chapters: 40 }, ... }
 */
export const BOOK_METADATA: Record<string, { chapters: number }> = ${JSON.stringify(bookMetadata, null, 2)};

/**
 * 장별 최대 절 수
 * 예: { "창": { 1: 31, 2: 25, ... }, "출": { 1: 22, ... }, ... }
 */
export const CHAPTER_VERSES: Record<string, Record<number, number>> = ${JSON.stringify(chapterVerses, null, 2)};

/**
 * 다음 성경책 가져오기 (순환)
 * @param currentBook 현재 책 이름
 * @returns 다음 책 이름 (요한계시록 다음은 창세기)
 */
export function getNextBook(currentBook: string): string {
  const index = BIBLE_BOOKS.indexOf(currentBook);
  if (index === -1) {
    throw new Error(\`알 수 없는 성경책: \${currentBook}\`);
  }
  if (index === BIBLE_BOOKS.length - 1) {
    return BIBLE_BOOKS[0]; // 순환: 계시록 → 창세기
  }
  return BIBLE_BOOKS[index + 1];
}

/**
 * 장의 최대 절 수 가져오기
 * @param book 책 이름
 * @param chapter 장 번호
 * @returns 최대 절 수 (없으면 0)
 */
export function getMaxVerseInChapter(book: string, chapter: number): number {
  return CHAPTER_VERSES[book]?.[chapter] ?? 0;
}

/**
 * 책의 최대 장 수 가져오기
 * @param book 책 이름
 * @returns 최대 장 수 (없으면 0)
 */
export function getMaxChapterInBook(book: string): number {
  return BOOK_METADATA[book]?.chapters ?? 0;
}

/**
 * 성경 구절이 유효한지 검증
 * @param book 책 이름
 * @param chapter 장 번호
 * @param verse 절 번호
 * @returns 유효 여부
 */
export function isValidVerse(book: string, chapter: number, verse: number): boolean {
  const maxChapter = getMaxChapterInBook(book);
  if (chapter < 1 || chapter > maxChapter) {
    return false;
  }

  const maxVerse = getMaxVerseInChapter(book, chapter);
  return verse >= 1 && verse <= maxVerse;
}
`;

// 5. 파일 쓰기
try {
  fs.writeFileSync(outputPath, tsContent, 'utf8');
  console.log(`✅ bible-metadata.ts 생성 완료!`);
  console.log(`   - ${books.length}권 성경`);
  console.log(`   - ${Object.keys(chapterVerses).reduce((sum, book) => sum + Object.keys(chapterVerses[book]).length, 0)}개 장`);
} catch (error) {
  console.error('❌ 파일 쓰기 실패:', error.message);
  process.exit(1);
}

// 6. 샘플 출력
console.log('\n📊 샘플 메타데이터:');
console.log(`   - 창세기: ${bookMetadata['창'].chapters}장`);
console.log(`   - 창세기 1장: ${chapterVerses['창'][1]}절`);
console.log(`   - 시편: ${bookMetadata['시'].chapters}장`);
console.log(`   - 요한복음: ${bookMetadata['요'].chapters}장`);
console.log(`   - 요한복음 3장: ${chapterVerses['요'][3]}절`);

console.log('\n🎉 성경 메타데이터 생성 완료!');
