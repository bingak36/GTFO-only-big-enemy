namespace BigEnemyMode
{
    /// <summary>
    /// GTFO EnemyDataBlock 의 persistentID 값 정의.
    ///
    /// 게임 내 실제 ID는 아래 방법으로 확인할 수 있습니다:
    ///   1. GTFO 설치 폴더 > GameData_* > EnemyDataBlock.json 열기
    ///   2. 각 항목의 "persistentID" 값 확인
    ///
    /// GTFO R8 기준 일반적으로 알려진 ID (버전에 따라 다를 수 있음):
    /// </summary>
    public static class EnemyIDs
    {
        // ─── 스트라이커 계열 ───────────────────────────────────────────
        /// <summary>일반 스트라이커 (Baby Striker 포함 가능)</summary>
        public const uint Striker        = 20u;

        /// <summary>빅 스트라이커</summary>
        public const uint BigStriker     = 21u;

        // ─── 슈터 계열 ────────────────────────────────────────────────
        /// <summary>일반 슈터</summary>
        public const uint Shooter        = 25u;

        /// <summary>빅 슈터</summary>
        public const uint BigShooter     = 26u;

        // ─── 교체 매핑 테이블 ─────────────────────────────────────────
        /// <summary>
        /// Key: 원본 적 ID, Value: 교체할 적 ID
        /// 이 딕셔너리가 모드의 핵심 교체 규칙입니다.
        /// ID가 맞지 않으면 이 값만 수정하면 됩니다.
        /// </summary>
        public static readonly Dictionary<uint, uint> ReplacementMap = new()
        {
            { Striker,  BigStriker  },
            { Shooter,  BigShooter  },
        };
    }
}
