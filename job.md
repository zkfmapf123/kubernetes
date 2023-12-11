# Job

- 지속적으로 실행되는 서비스가 아닌, 특정작업을 수행하고 종료해야 하는 경우
- 특정 동작을 수행하고 종료하는 작업을 정의하기 위한 리소스
- 내부적으로 파드를 생성하여 작업을 수행
- pod의 상태가 <b>running</b> 상태가 아닌, <b>completed</b>가 되는것이 최종상태
- 실패 시 재시작, 작업 수행 회수, 동시 실행 수 세부옵션 제공
- <b>job 같은 경우에는 restartPolicy를 Never, onFailure로 정의해야 함</b>

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: job
spec:
  activeDeadlineSeconds: 60 ## 60초 이내에 끝나지 않으면 종료
  completions: 10 ## number of pods
  parallelism: 2 ## 2개씩 병렬 처리
  template:
    spec:
      restartPolicy: Never ## never, onFailure로 정의해야 함
      containers:
        - name: job
          image: ubuntu:focal
          command: ['sh', '-c', 'echo hello world']
```

## Command

```sh
    kc apply -f job.yaml
    kc logs -f [job-pod]
```

# Cronjob

- Linux에 CronJob과 동일
- 주기적으로 특정 동작을 수행하고 종료하는 작업을 정의하기 위한 리소스
- 주로 데이터를 백업하거나, 데이터 점검 및 알림전송등의 목적으로 사용

## Command

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-every-min
spec:
  schedule: '*/1 * * * *' ## cron
  successfulJobsHistoryLimit: 5 ## 성공한 job 5개만 유지
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: hello
              image: ubuntu:focal
              command: ['sh', '-c', 'echo hello world']
```

```sh
    kc apply -f cronjob.yaml
    kc get pods --watch -o wide
```
