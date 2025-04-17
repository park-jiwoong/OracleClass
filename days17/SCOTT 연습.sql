/* 계정 */
CREATE TABLE account (
	accountID INT NOT NULL, /* 계정 ID */
	email VARCHAR2(255) NOT NULL, /* 이메일 */
	phoneNumber VARCHAR2(30) NOT NULL, /* 전화번호 */
	pw VARCHAR2(255) NOT NULL, /* 비밀번호 */
	gender CHAR(1) NOT NULL, /* 성별 */
	profilepw VARCHAR2(6) NOT NULL, /* 본인확인pin번호 */
	adultverification CHAR(1) /* 성인인증 */
);

CREATE UNIQUE INDEX PK_account
	ON account (
		accountID ASC
	);

ALTER TABLE account
	ADD
		CONSTRAINT PK_account
		PRIMARY KEY (
			accountID
		);

/* 프로필 */
CREATE TABLE profile (
	profileID INT NOT NULL, /* 프로필 ID */
	defaultLang VARCHAR2(100) NOT NULL, /* 기본사용언어 */
	nickname VARCHAR2(200) NOT NULL, /* 닉네임 */
	profileimage VARCHAR2(255), /* 프로필사진 */
	accessRestriction VARCHAR2(100), /* 접근제한 */
	accountID INT NOT NULL, /* 계정 ID */
	subtitleSettingID INT /* 자막표시 ID */
);

CREATE UNIQUE INDEX PK_profile
	ON profile (
		profileID ASC
	);

ALTER TABLE profile
	ADD
		CONSTRAINT PK_profile
		PRIMARY KEY (
			profileID
		);

/* 자막표시설정 */
CREATE TABLE subtitleSetting (
	subtitleSettingID INT NOT NULL, /* 자막표시 ID */
	font VARCHAR2(100), /* 글꼴 */
	fontSize VARCHAR2(50), /* 크기 */
	fontEffect VARCHAR2(50) /* 효과 */
);

CREATE UNIQUE INDEX PK_subtitleSetting
	ON subtitleSetting (
		subtitleSettingID ASC
	);

ALTER TABLE subtitleSetting
	ADD
		CONSTRAINT PK_subtitleSetting
		PRIMARY KEY (
			subtitleSettingID
		);

/* 시청기록 */
CREATE TABLE viewingHistory (
	viewingHistoryID INT NOT NULL, /* 시청기록 ID */
	lastViewat DATE NOT NULL, /* 마지막 시청 시각 */
	isCompleted CHAR(1), /* 시청 완료 여부 */
	profileID INT NOT NULL, /* 프로필 ID */
	videoID INT NOT NULL, /* 영상 ID */
	defaultLang VARCHAR2(30) /* 기본사용언어 */
);

CREATE UNIQUE INDEX PK_viewingHistory
	ON viewingHistory (
		viewingHistoryID ASC
	);

ALTER TABLE viewingHistory
	ADD
		CONSTRAINT PK_viewingHistory
		PRIMARY KEY (
			viewingHistoryID
		);

/* 찜하기 목록 */
CREATE TABLE wishList (
	wishlistID INT NOT NULL, /* 찜하기 ID */
	defaultLang VARCHAR2(30), /* 기본사용언어 */
	profileID INT, /* 프로필 ID */
	videoID2 INT /* 영상 ID */
);

CREATE UNIQUE INDEX PK_wishList
	ON wishList (
		wishlistID ASC
	);

ALTER TABLE wishList
	ADD
		CONSTRAINT PK_wishList
		PRIMARY KEY (
			wishlistID
		);

/* 사용중인 디바이스 */
CREATE TABLE device (
	deviceID INT NOT NULL, /* 사용디바이스 ID */
	deviceName VARCHAR2(100) NOT NULL, /* 디바이스명 */
	connectionTime DATE NOT NULL, /* 접속시간 */
	defaultLang VARCHAR2(30), /* 기본사용언어 */
	profileID INT /* 프로필 ID */
);

CREATE UNIQUE INDEX PK_device
	ON device (
		deviceID ASC
	);

ALTER TABLE device
	ADD
		CONSTRAINT PK_device
		PRIMARY KEY (
			deviceID
		);

/* 멤버쉽 */
CREATE TABLE membership (
	membershipID INT NOT NULL, /* 멤버쉽 ID */
	price INT NOT NULL, /* 월요금 */
	resolution VARCHAR2(100) NOT NULL, /* 해상도 */
	concurrentConnection INT NOT NULL, /* 접속자수 */
	ad INT NOT NULL, /* 광고여부 */
	audiotrack INT NOT NULL /* 오디오 트랙 ID */
);

CREATE UNIQUE INDEX PK_membership
	ON membership (
		membershipID ASC
	);

ALTER TABLE membership
	ADD
		CONSTRAINT PK_membership
		PRIMARY KEY (
			membershipID
		);

/* 결제방식 */
CREATE TABLE payment (
	paymentType INT NOT NULL, /* 결제방식 ID */
	paydate DATE NOT NULL, /* 결제날짜 */
	paymethod VARCHAR2(100) NOT NULL, /* 결제수단 */
	payamount VARCHAR2(100) NOT NULL, /* 결제금액 */
	useperiod VARCHAR2(200) NOT NULL, /* 기간설명 */
	membershipID INT, /* 멤버쉽 ID */
	accountID INT, /* 계정 ID */
	deviceID INT /* 사용디바이스 ID */
);

CREATE UNIQUE INDEX PK_payment
	ON payment (
		paymentType ASC
	);

ALTER TABLE payment
	ADD
		CONSTRAINT PK_payment
		PRIMARY KEY (
			paymentType
		);

/* 다운로드 */
CREATE TABLE download (
	downID INT NOT NULL, /* 다운로드 ID */
	deviceID INT, /* 사용디바이스 ID */
	videoID2 INT /* 영상 ID */
);

CREATE UNIQUE INDEX PK_download
	ON download (
		downID ASC
	);

ALTER TABLE download
	ADD
		CONSTRAINT PK_download
		PRIMARY KEY (
			downID
		);

/* 특징별시청횟수 */
CREATE TABLE featureViewCnt (
	featureViewCntID INT NOT NULL, /* 특징횟수 ID */
	cnt INT NOT NULL, /* count */
	defaultLang VARCHAR2(100), /* 기본사용언어 */
	profileID INT NOT NULL, /* 프로필 ID */
	featureID INT /* 특징 ID */
);

CREATE UNIQUE INDEX PK_featureViewCnt
	ON featureViewCnt (
		featureViewCntID ASC
	);

ALTER TABLE featureViewCnt
	ADD
		CONSTRAINT PK_featureViewCnt
		PRIMARY KEY (
			featureViewCntID
		);

/* 장르별시청횟수 */
CREATE TABLE genreViewCnt (
	genreViewCntID INT NOT NULL, /* 장르횟수 ID */
	cnt INT NOT NULL, /* count */
	defaultLang VARCHAR2(100), /* 기본사용언어 */
	profileID INT NOT NULL, /* 프로필 ID */
	genreID INT /* 장르 ID */
);

CREATE UNIQUE INDEX PK_genreViewCnt
	ON genreViewCnt (
		genreViewCntID ASC
	);

ALTER TABLE genreViewCnt
	ADD
		CONSTRAINT PK_genreViewCnt
		PRIMARY KEY (
			genreViewCntID
		);

/* 콘텐츠 */
CREATE TABLE content (
	contentID INT NOT NULL, /* 콘텐츠 ID */
	contentType VARCHAR2(50) NOT NULL, /* 콘텐츠 유형 */
	title VARCHAR2(200) NOT NULL, /* 제목 */
	originTitle VARCHAR2(200), /* 원제 */
	description VARCHAR2(3000), /* 설명 */
	releaseDate DATE NOT NULL, /* 출시 일자 */
	releaseYear NUMBER(4) NOT NULL, /* 출시 년도 */
	publicDate DATE NOT NULL, /* 공개일 */
	runtime INT NOT NULL, /* 재생 시간(분) */
	thumbnailURL VARCHAR2(255), /* 썸네일 이미지 URL */
	mainImage VARCHAR2(255), /* 대표 이미지 URL */
	originLang VARCHAR2(50) NOT NULL, /* 원본 언어 */
	productionCountry VARCHAR2(50) NOT NULL, /* 제작 국가 */
	registeredAt DATE NOT NULL, /* 등록 일시 */
	updatedAt DATE, /* 수정 일시 */
	availableCountry VARCHAR2(50) NOT NULL, /* 공개 국가 */
	ratingScore NUMBER(3,1), /* 평점 */
	videoQuality VARCHAR2(20) NOT NULL /* 제공 화질 */
);

CREATE UNIQUE INDEX PK_content
	ON content (
		contentID ASC
	);

ALTER TABLE content
	ADD
		CONSTRAINT PK_content
		PRIMARY KEY (
			contentID
		);

/* 영상 */
CREATE TABLE video (
	videoID INT NOT NULL, /* 영상 ID */
	seasonNum INT, /* 시즌 번호 */
	epiNum INT, /* 에피소드 번호 */
	epiTitle VARCHAR2(150), /* 에피소드 제목 */
	epiDescription VARCHAR2(1000), /* 에피소드 설명 */
	epiruntime INT, /* 에피소드 재생시간(분) */
	epiImageURL VARCHAR2(255), /* 에피소드 썸네일 URL */
	releaseDate DATE, /* 공개일 */
	totalViewingTime INT NOT NULL, /* 총 시청 시간(초) */
	contentID INT NOT NULL, /* 콘텐츠 ID */
	audioLangID INT /* 음성언어 ID */
);

CREATE UNIQUE INDEX PK_video
	ON video (
		videoID ASC
	);

ALTER TABLE video
	ADD
		CONSTRAINT PK_video
		PRIMARY KEY (
			videoID
		);

/* 장르 */
CREATE TABLE genre (
	genreID INT NOT NULL, /* 장르 ID */
	genreName VARCHAR2(20) /* 장르명 */
);

CREATE UNIQUE INDEX PK_genre
	ON genre (
		genreID ASC
	);

ALTER TABLE genre
	ADD
		CONSTRAINT PK_genre
		PRIMARY KEY (
			genreID
		);

/* 장르 리스트 */
CREATE TABLE genreList (
	genreListid INT NOT NULL, /* 장르리스트 ID */
	genreID INT NOT NULL, /* 장르 ID */
	contentID INT NOT NULL /* 콘텐츠 ID */
);

CREATE UNIQUE INDEX PK_genreList
	ON genreList (
		genreListid ASC
	);

ALTER TABLE genreList
	ADD
		CONSTRAINT PK_genreList
		PRIMARY KEY (
			genreListid
		);

/* 배우 */
CREATE TABLE actor (
	actorid INT NOT NULL, /* 인물 ID */
	name VARCHAR2(255), /* 인물 이름 */
	birthDate DATE /* 생년월일 */
);

CREATE UNIQUE INDEX PK_actor
	ON actor (
		actorid ASC
	);

ALTER TABLE actor
	ADD
		CONSTRAINT PK_actor
		PRIMARY KEY (
			actorid
		);

/* 배우들 */
CREATE TABLE actorList (
	actorListid INT NOT NULL, /* 배우리스트 ID */
	role VARCHAR2(255), /* 역할 */
	roleName VARCHAR2(255), /* 배역명 */
	contentID INT NOT NULL, /* 콘텐츠 ID */
	actorid INT NOT NULL /* 인물 ID */
);

CREATE UNIQUE INDEX PK_actorList
	ON actorList (
		actorListid ASC
	);

ALTER TABLE actorList
	ADD
		CONSTRAINT PK_actorList
		PRIMARY KEY (
			actorListid
		);

/* 오디오 트랙 */
CREATE TABLE audioTrack (
	audioTrackID INT NOT NULL, /* 오디오 트랙 ID */
	audioDescription VARCHAR2(255) /* 오디오 설명 */
);

CREATE UNIQUE INDEX PK_audioTrack
	ON audioTrack (
		audioTrackID ASC
	);

ALTER TABLE audioTrack
	ADD
		CONSTRAINT PK_audioTrack
		PRIMARY KEY (
			audioTrackID
		);

/* 트레일러 */
CREATE TABLE trailer (
	trailerID INT NOT NULL, /* 트레일러 ID */
	trailerURL VARCHAR2(255) NOT NULL, /* 트레일러 URL */
	title VARCHAR2(255) NOT NULL, /* 제목 */
	videoID INT NOT NULL, /* 영상 ID */
	audioLangID INT /* 음성언어 ID */
);

CREATE UNIQUE INDEX PK_trailer
	ON trailer (
		trailerID ASC
	);

ALTER TABLE trailer
	ADD
		CONSTRAINT PK_trailer
		PRIMARY KEY (
			trailerID
		);

/* 사용자 평가 */
CREATE TABLE userRating (
	ratingID INT NOT NULL, /* 평가 ID */
	ratingType INT NOT NULL, /* 평가 유형 */
	ratingTime DATE NOT NULL, /* 평가 시각 */
	profileID INT NOT NULL, /* 프로필 ID */
	contentID INT NOT NULL, /* 콘텐츠 ID */
	defaultLang VARCHAR2(30) /* 기본사용언어 */
);

CREATE UNIQUE INDEX PK_userRating
	ON userRating (
		ratingID ASC
	);

ALTER TABLE userRating
	ADD
		CONSTRAINT PK_userRating
		PRIMARY KEY (
			ratingID
		);

/* 특징 */
CREATE TABLE feature (
	featureID INT NOT NULL, /* 특징 ID */
	featureName VARCHAR2(50) NOT NULL /* 특징명 */
);

CREATE UNIQUE INDEX PK_feature
	ON feature (
		featureID ASC
	);

ALTER TABLE feature
	ADD
		CONSTRAINT PK_feature
		PRIMARY KEY (
			featureID
		);

/* 국가 */
CREATE TABLE Country (
	countryID INT NOT NULL, /* 국가 ID */
	baseLanguege VARCHAR2(30), /* 기본언어 */
	contentRatingID INT /* 시청등급 ID */
);

CREATE UNIQUE INDEX PK_Country
	ON Country (
		countryID ASC
	);

ALTER TABLE Country
	ADD
		CONSTRAINT PK_Country
		PRIMARY KEY (
			countryID
		);

/* 시청 등급 */
CREATE TABLE contentRating (
	contentRatingID INT NOT NULL, /* 시청 등급 ID */
	ratingLabel VARCHAR2(50), /* 시청 등급 */
	contentID INT, /* 콘텐츠 ID */
	countryID INT /* 국가 ID */
);

CREATE UNIQUE INDEX PK_contentRating
	ON contentRating (
		contentRatingID ASC
	);

ALTER TABLE contentRating
	ADD
		CONSTRAINT PK_contentRating
		PRIMARY KEY (
			contentRatingID
		);

/* 크리에이터 */
CREATE TABLE creator (
	creatorID INT NOT NULL, /* 크리에이터 ID */
	creatorName VARCHAR2(255) /* 크리에이터 이름 */
);

CREATE UNIQUE INDEX PK_creator
	ON creator (
		creatorID ASC
	);

ALTER TABLE creator
	ADD
		CONSTRAINT PK_creator
		PRIMARY KEY (
			creatorID
		);

/* 자막 */
CREATE TABLE subtitle (
	subtitleID INT NOT NULL, /* 자막 ID */
	subtitleFileURL VARCHAR2(255), /* 자막 파일 URL */
	screenDiscription VARCHAR2(30), /* 화면해설 */
	videoID INT NOT NULL, /* 영상 ID */
	subtitleSettingID INT /* 자막표시 ID */
);

CREATE UNIQUE INDEX PK_subtitle
	ON subtitle (
		subtitleID ASC
	);

ALTER TABLE subtitle
	ADD
		CONSTRAINT PK_subtitle
		PRIMARY KEY (
			subtitleID
		);

/* 콘텐츠 제작자들 */
CREATE TABLE creatorList (
	creatorListid INT NOT NULL, /* 크리에이터리스트 ID */
	contentID INT, /* 콘텐츠 ID */
	creatorID INT /* 크리에이터 ID */
);

CREATE UNIQUE INDEX PK_creatorList
	ON creatorList (
		creatorListid ASC
	);

ALTER TABLE creatorList
	ADD
		CONSTRAINT PK_creatorList
		PRIMARY KEY (
			creatorListid
		);

/* 특징 리스트 */
CREATE TABLE featureList (
	featureListid INT NOT NULL, /* 특징리스트 ID */
	featureID INT, /* 특징 ID */
	contentID INT /* 콘텐츠 ID */
);

CREATE UNIQUE INDEX PK_featureList
	ON featureList (
		featureListid ASC
	);

ALTER TABLE featureList
	ADD
		CONSTRAINT PK_featureList
		PRIMARY KEY (
			featureListid
		);

/* 음성언어 */
CREATE TABLE audioLang (
	audioLangID INT NOT NULL, /* 음성언어 ID */
	Language VARCHAR2() NOT NULL, /* 언어 */
	audioTrackID INT NOT NULL /* 오디오 트랙 ID */
);

CREATE UNIQUE INDEX PK_audioLang
	ON audioLang (
		audioLangID ASC
	);

ALTER TABLE audioLang
	ADD
		CONSTRAINT PK_audioLang
		PRIMARY KEY (
			audioLangID
		);

ALTER TABLE profile
	ADD
		CONSTRAINT FK_account_TO_profile
		FOREIGN KEY (
			accountID
		)
		REFERENCES account (
			accountID
		);

ALTER TABLE profile
	ADD
		CONSTRAINT FK_subtitleSetting_TO_profile
		FOREIGN KEY (
			subtitleSettingID
		)
		REFERENCES subtitleSetting (
			subtitleSettingID
		);

ALTER TABLE viewingHistory
	ADD
		CONSTRAINT FK_profile_TO_viewingHistory
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE viewingHistory
	ADD
		CONSTRAINT FK_video_TO_viewingHistory
		FOREIGN KEY (
			videoID
		)
		REFERENCES video (
			videoID
		);

ALTER TABLE wishList
	ADD
		CONSTRAINT FK_profile_TO_wishList
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE wishList
	ADD
		CONSTRAINT FK_video_TO_wishList
		FOREIGN KEY (
			videoID2
		)
		REFERENCES video (
			videoID
		);

ALTER TABLE device
	ADD
		CONSTRAINT FK_profile_TO_device
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE membership
	ADD
		CONSTRAINT FK_audioTrack_TO_membership
		FOREIGN KEY (
			audiotrack
		)
		REFERENCES audioTrack (
			audioTrackID
		);

ALTER TABLE payment
	ADD
		CONSTRAINT FK_membership_TO_payment
		FOREIGN KEY (
			membershipID
		)
		REFERENCES membership (
			membershipID
		);

ALTER TABLE payment
	ADD
		CONSTRAINT FK_account_TO_payment
		FOREIGN KEY (
			accountID
		)
		REFERENCES account (
			accountID
		);

ALTER TABLE payment
	ADD
		CONSTRAINT FK_device_TO_payment
		FOREIGN KEY (
			deviceID
		)
		REFERENCES device (
			deviceID
		);

ALTER TABLE download
	ADD
		CONSTRAINT FK_device_TO_download
		FOREIGN KEY (
			deviceID
		)
		REFERENCES device (
			deviceID
		);

ALTER TABLE download
	ADD
		CONSTRAINT FK_video_TO_download
		FOREIGN KEY (
			videoID2
		)
		REFERENCES video (
			videoID
		);

ALTER TABLE featureViewCnt
	ADD
		CONSTRAINT FK_profile_TO_featureViewCnt
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE featureViewCnt
	ADD
		CONSTRAINT FK_feature_TO_featureViewCnt
		FOREIGN KEY (
			featureID
		)
		REFERENCES feature (
			featureID
		);

ALTER TABLE genreViewCnt
	ADD
		CONSTRAINT FK_profile_TO_genreViewCnt
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE genreViewCnt
	ADD
		CONSTRAINT FK_genre_TO_genreViewCnt
		FOREIGN KEY (
			genreID
		)
		REFERENCES genre (
			genreID
		);

ALTER TABLE video
	ADD
		CONSTRAINT FK_content_TO_video
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE video
	ADD
		CONSTRAINT FK_audioLang_TO_video
		FOREIGN KEY (
			audioLangID
		)
		REFERENCES audioLang (
			audioLangID
		);

ALTER TABLE genreList
	ADD
		CONSTRAINT FK_genre_TO_genreList
		FOREIGN KEY (
			genreID
		)
		REFERENCES genre (
			genreID
		);

ALTER TABLE genreList
	ADD
		CONSTRAINT FK_content_TO_genreList
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE actorList
	ADD
		CONSTRAINT FK_content_TO_actorList
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE actorList
	ADD
		CONSTRAINT FK_actor_TO_actorList
		FOREIGN KEY (
			actorid
		)
		REFERENCES actor (
			actorid
		);

ALTER TABLE trailer
	ADD
		CONSTRAINT FK_video_TO_trailer
		FOREIGN KEY (
			videoID
		)
		REFERENCES video (
			videoID
		);

ALTER TABLE trailer
	ADD
		CONSTRAINT FK_audioLang_TO_trailer
		FOREIGN KEY (
			audioLangID
		)
		REFERENCES audioLang (
			audioLangID
		);

ALTER TABLE userRating
	ADD
		CONSTRAINT FK_content_TO_userRating
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE userRating
	ADD
		CONSTRAINT FK_profile_TO_userRating
		FOREIGN KEY (
			profileID
		)
		REFERENCES profile (
			profileID
		);

ALTER TABLE contentRating
	ADD
		CONSTRAINT FK_content_TO_contentRating
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE contentRating
	ADD
		CONSTRAINT FK_Country_TO_contentRating
		FOREIGN KEY (
			countryID
		)
		REFERENCES Country (
			countryID
		);

ALTER TABLE subtitle
	ADD
		CONSTRAINT FK_video_TO_subtitle
		FOREIGN KEY (
			videoID
		)
		REFERENCES video (
			videoID
		);

ALTER TABLE subtitle
	ADD
		CONSTRAINT FK_subtitleSetting_TO_subtitle
		FOREIGN KEY (
			subtitleSettingID
		)
		REFERENCES subtitleSetting (
			subtitleSettingID
		);

ALTER TABLE creatorList
	ADD
		CONSTRAINT FK_content_TO_creatorList
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE creatorList
	ADD
		CONSTRAINT FK_creator_TO_creatorList
		FOREIGN KEY (
			creatorID
		)
		REFERENCES creator (
			creatorID
		);

ALTER TABLE featureList
	ADD
		CONSTRAINT FK_feature_TO_featureList
		FOREIGN KEY (
			featureID
		)
		REFERENCES feature (
			featureID
		);

ALTER TABLE featureList
	ADD
		CONSTRAINT FK_content_TO_featureList
		FOREIGN KEY (
			contentID
		)
		REFERENCES content (
			contentID
		);

ALTER TABLE audioLang
	ADD
		CONSTRAINT FK_audioTrack_TO_audioLang
		FOREIGN KEY (
			audioTrackID
		)
		REFERENCES audioTrack (
			audioTrackID
		);