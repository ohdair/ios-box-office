# iOS-Box-Office


|Title|Description|
|---|---|
한 줄 소개|영화진흥위원회 OpenAPI를 활용하여 영화 정보를 확인할 수 있는 서비스
프로젝트 진행기간|23. 04. 24 ~ 23. 05. 16

## 📱 구현 화면
|영화 선택|날짜 선택|
|---|---|
|![Simulator Screen Recording - iPhone 14 Pro - 2023-07-04 at 02 54 53](https://github.com/ohdair/ios-box-office/assets/79438622/2a46de8e-fe8b-440c-9d42-d2c48a4ef12e)|![Simulator Screen Recording - iPhone 14 Pro - 2023-07-04 at 02 55 19](https://github.com/ohdair/ios-box-office/assets/79438622/b9c29533-aa65-41fb-bbd8-79e061c4c4c1)|

## 📚 Step 설명
### [ Step 1 ]
- 영화진흥위원회의 일별 박스오피스 API 문서의 데이터 형식을 고려하여 모델 타입을 구현

- 제공된 JSON 데이터를 구현한 Model 타입으로 Parsing 할 수 있는지에 대한 단위 테스트(Unit Test)를 진행



### [ Step 2 ]
- 네트워크 통신을 담당할 타입을 설계 및 구현

- 영화진흥위원회의 일별 박스오피스 API 문서의 데이터 형식을 고려하여 서버와 실제로 데이터를 주고받도록 구현

  - 오늘의 일일 박스오피스 조회

  - 영화 개별 상세 조회



### [ Step 3 ]
- Step 2에서 구현한 네트워킹 기능을 통해 실제로 상품목록을 API 서버에 요청

- 어제의 박스오피스를 볼 수 있는 화면을 구현

- 리스트를 아래로 잡아끌어서 놓으면 리스트를 새로고침(당겨서 새로고침)

- 처음 목록을 로드할 때, 사용자에게 빈 화면만 보여주는 대신, 로드 중임을 알 수 있게 처리

- 화면 상단에는 날짜를 표기

- 리스트 형태로 박스오피스 정보를 표기

- 박스오피스 정보의 각 열에 표기할 필수정보

  - 맨 왼쪽에는 영화의 현재 등수를 표기

    - 신규 영화면 등수 아래에 신작이라고 표기

    - 기존 영화면 어제와 비교한 등락을 표기

      - 순위 상승 : 빨간 화살표 + 등락 편차

      - 순위 하락 : 파란 화살표 + 등락 편차

      - 변동 없음 : - 표기

  - 해당 일자의 관객수와 누적 관객수를 표기
  
    - 숫자가 세 자리 이상 넘어가면 ,를 활용하여 읽기 쉽도록 처리. 예) 10,000

### [ Step 4 ]

- 영화의 상세내용을 확인할 수 있는 화면을 구현

- 표시할 영화 정보

  - 제목
  
  - 포스터 이미지
  - 감독
  - 제작년도
  - 개봉일
  - 상영시간
  - 관람등급
  - 제작국가
  - 장르
  - 배우
- 영화 포스터 이미지는 다음 이미지 검색 API를 활용합니다
  - 영화 포스터 이미지는 [영화제목] + [영화 포스터]로 이미지 검색하여 제일 첫 이미지를 사용합니다
    - 예) "실미도 영화 포스터" 검색
  - 이미지가 로드되기 전에는 이미지가 로드중임을 알 수 있도록 적절히 처리해주세요
- 내용이 길어지면 위아래로 스크롤 할 수 있도록 구현해주세요

### [ Step 5 ]

- 날짜를 선택하고, 선택한 날짜에 따라 박스오피스 정보를 새로 수신하여 화면에 표시
- 선택할 수 있는 날짜는 오늘까지로 제한
- 날짜선택 화면의 달력에는 현재 선택된 날짜가 미리 선택

## 📓 학습내용 요점
1. 네트워킹을 통한 데이터를 DTO로 변환 후, 프로젝트에서 사용할 요소들만 뽑아서 Model로 변환
2. 순위 등락을 표기할 떄, stackView로 레이아웃을 설정하지 않고 AttributedString을 이용하여 image를 text로 입력하도록 변경
   
   <img src="https://user-images.githubusercontent.com/79438622/237252302-b0d90328-1b81-4d68-b6df-1fa91d787d90.png">  <img src="https://user-images.githubusercontent.com/79438622/237252312-69cf981b-829f-478b-91a2-ac21fe129db9.png">
```Swift
private func rankStatusText(_ rank: Rank) -> NSAttributedString {
    if rank.isEntry {
        return NSAttributedString(string: "신작", attributes: [.foregroundColor: UIColor.systemPink])
    }

    return varianceStatusText(of: rank.variance)
}

private func varianceStatusText(of variance: Int) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: "")
    let imageAttachment = NSTextAttachment()

    if variance > 0 {
        imageAttachment.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.systemRed)
        attributedString.append(NSAttributedString(string: String(variance)))
    } else if variance < 0 {
        imageAttachment.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.systemBlue)
        attributedString.append(NSAttributedString(string: String(abs(variance))))
    } else {
        imageAttachment.image = UIImage(systemName: "minus")?.withTintColor(.gray)
    }
    attributedString.insert(NSAttributedString(attachment: imageAttachment), at: 0)

    return attributedString
}
```
3. API마다 HTTPCode에 값을 던지더라도 에러 메시지가 달라지는 것을 확인해서 서버 에러 데이터 타입
```Swift
struct ErrorDTO: Decodable {
    let message: String?

    func convert(with httpCode: Int) -> HTTPError? {
        guard let message = message else { return nil }
        switch httpCode {
        case 200:
            return HTTPError.requestError(message: message)
        case 400:
            return HTTPError.requestError(message: message)
        case 401:
            return HTTPError.authenticationError(message: message)
        case 403:
            return HTTPError.authorizationPermissonError(message: message)
        case 500, 502:
            return HTTPError.systemError(message: message)
        case 503:
            return HTTPError.serviceMaintenance(message: message)
        default:
            return HTTPError.notFound
        }
    }
}
```

## 🚀 트러블 슈팅
1. 네트워킹을 통해 DTO를 변환하는 과정, 실패에 대한 에러를 확인했지만 속성 중에 어디서 문제가 생겼는지 찾는데 오래 걸리는 문제가 발생
   
   수동으로 디코딩하도록 변경, 특정 속성에서 문제가 생기면 throws 되며 해결
   
   [공식 문서](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)
```Swift
extension DailyBoxOfficeDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decode(String.self, forKey: .index)
        rank = try container.decode(String.self, forKey: .rank)
        rankVariance = try container.decode(String.self, forKey: .rankVariance)
        rankOldAndNew = try container.decode(String.self, forKey: .rankOldAndNew)
        movieCode = try container.decode(String.self, forKey: .movieCode)
        movieName = try container.decode(String.self, forKey: .movieName)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        salesAmount = try container.decode(String.self, forKey: .salesAmount)
        salesShare = try container.decode(String.self, forKey: .salesShare)
        salesVariance = try container.decode(String.self, forKey: .salesVariance)
        salesChange = try container.decode(String.self, forKey: .salesChange)
        salesAccumulate = try container.decode(String.self, forKey: .salesAccumulate)
        audiencePerDay = try container.decode(String.self, forKey: .audiencePerDay)
        audienceVariance = try container.decode(String.self, forKey: .audienceVariance)
        audienceChange = try container.decode(String.self, forKey: .audienceChange)
        audienceAccumlate = try container.decode(String.self, forKey: .audienceAccumlate)
        screenCount = try container.decode(String.self, forKey: .screenCount)
        showCount = try container.decode(String.self, forKey: .showCount)
    }
}
```
