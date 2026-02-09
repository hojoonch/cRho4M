#!/bin./bash

read -p  " 추가할 리모트 디바이스의 시스템 ID는? " remoteName

# 입력값이 비어있는지 확인
if [ -z "$folder_name" ]; then
    echo "오류: 폴더 이름을 입력하지 않았습니다."
    exit 1
fi

# 폴더 생성 (-p 옵션은 이미 존재할 경우 에러를 방지함)
mkdir -p "$folder_name"
mkdir -p "$folder_name"/{DataDC, DataIP, DataTestADC, DataTestEl, JSON}
mkdir -p "$folder_name"/DataDC/Processed
mkdir -p "$folder_name"/DataIP/Processed
mkdir -p "$folder_name"/DataTestADC/Processed
mkdir -p "$folder_name"/DataTestEl/Processed

echo " JSON/BasicSetting.json 파일의 끝에 리모트 디바이스의 이름을 추가하세요. 두번째 이후에 추가" 