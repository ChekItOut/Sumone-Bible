-- Cron Job: 매일 UTC 15:00 (KST 자정) 실행
-- generate-daily-verse Edge Function 자동 호출

-- 기존 Cron Job 삭제 (있으면)
SELECT cron.unschedule('generate-daily-verse-job');

-- Cron Job 생성
-- '0 15 * * *' = 매일 UTC 15:00 (한국 시간 자정)
SELECT cron.schedule(
  'generate-daily-verse-job',
  '0 15 * * *',
  $$
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/generate-daily-verse',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer YOUR_SERVICE_ROLE_KEY'
    ),
    body := jsonb_build_object()
  );
  $$
);

-- Cron Job 목록 확인
SELECT
  jobid,
  jobname,
  schedule,
  active,
  command
FROM cron.job
WHERE jobname = 'generate-daily-verse-job';

-- IMPORTANT: 이 파일을 실행하기 전에:
-- 1. 'your-project.supabase.co'를 실제 Supabase 프로젝트 URL로 변경
-- 2. 'YOUR_SERVICE_ROLE_KEY'를 실제 Service Role Key로 변경
--
-- 예시:
-- url := 'https://abcd1234.supabase.co/functions/v1/generate-daily-verse'
-- 'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
