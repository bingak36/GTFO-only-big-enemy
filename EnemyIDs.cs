using System.Collections.Generic;

namespace BigEnemyMode
{
    /// <summary>
    /// GTFO EnemyDataBlock persistentID 정의 (현재 버전 기준)
    /// 출처: GameData_EnemyDataBlock_bin.json
    /// </summary>
    public static class EnemyIDs
    {
        // ─── 일반 스트라이커 ──────────────────────────────────────────────
        public const uint Striker_Wave         = 13u;
        public const uint Striker_Patrol       = 32u;
        public const uint Striker_Wave_Fast    = 31u;
        public const uint Striker_Hibernate    = 24u;
        public const uint Striker_Hibernate2   = 70u;
        public const uint Striker_Bullrush     = 30u;
        public const uint Striker_Berserk      = 53u;

        // ─── 빅 스트라이커 ────────────────────────────────────────────────
        public const uint Striker_Big_Wave      = 16u;
        public const uint Striker_Big_Hibernate = 28u;
        public const uint Striker_Big_Bullrush  = 39u;

        // ─── 일반 슈터 ────────────────────────────────────────────────────
        public const uint Shooter_Wave      = 11u;
        public const uint Shooter_Hibernate = 26u;
        public const uint Shooter_Spread    = 52u;

        // ─── 빅 슈터 ──────────────────────────────────────────────────────
        public const uint Shooter_Big = 18u;

        // ─── 쉐도우 ───────────────────────────────────────────────────────
        public const uint Shadow            = 21u;
        public const uint Striker_Big_Shadow = 35u;

        // ─── 플라이어 ─────────────────────────────────────────────────────
        public const uint Flyer     = 42u;
        public const uint Flyer_Big = 45u;

        // ─── 교체 매핑 테이블 ─────────────────────────────────────────────
        public static readonly Dictionary<uint, uint> ReplacementMap = new()
        {
            // 스트라이커 → 빅 스트라이커
            { Striker_Wave,       Striker_Big_Wave      },
            { Striker_Patrol,     Striker_Big_Wave      },
            { Striker_Wave_Fast,  Striker_Big_Wave      },
            { Striker_Hibernate,  Striker_Big_Hibernate },
            { Striker_Hibernate2, Striker_Big_Hibernate },
            { Striker_Bullrush,   Striker_Big_Bullrush  },
            { Striker_Berserk,    Striker_Big_Wave      },

            // 슈터 → 빅 슈터
            { Shooter_Wave,      Shooter_Big },
            { Shooter_Hibernate, Shooter_Big },
            { Shooter_Spread,    Shooter_Big },

            // 쉐도우 → 빅 쉐도우
            { Shadow, Striker_Big_Shadow },

            // 플라이어 → 빅 플라이어
            { Flyer, Flyer_Big },
        };
    }
}
