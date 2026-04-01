using GameData;
using HarmonyLib;

namespace BigEnemyMode.Patches
{
    /// <summary>
    /// EnemyPopulationDataBlock 이 게임에 로드된 직후,
    /// 스트라이커/슈터 항목을 빅 버전 ID 로 교체합니다.
    ///
    /// 동작 흐름:
    ///   GameDataManager.Initialize()
    ///     → EnemyPopulationDataBlock.LoadAllBlocks()  ← 여기서 패치
    ///       → 각 블록의 m_enemyType ID 를 ReplacementMap 으로 교체
    /// </summary>
    [HarmonyPatch(typeof(GameDataManager), nameof(GameDataManager.Initialize))]
    internal static class EnemyPopulationPatch
    {
        /// <summary>
        /// GameDataManager.Initialize() 가 끝난 뒤 실행됩니다.
        /// DataBlock 이 전부 메모리에 올라온 상태이므로 안전하게 수정 가능합니다.
        /// </summary>
        [HarmonyPostfix]
        private static void Postfix()
        {
            Plugin.Log.LogInfo("EnemyPopulationDataBlock 패치 시작...");

            int replacedCount = 0;

            // 모든 EnemyPopulationDataBlock 순회
            foreach (var block in GameDataBlockBase<EnemyPopulationDataBlock>.GetAllBlocks())
            {
                // 각 블록 안의 population 배열 순회
                foreach (var entry in block.m_population)
                {
                    uint originalID = entry.enemyType.persistentID;

                    if (EnemyIDs.ReplacementMap.TryGetValue(originalID, out uint replacementID))
                    {
                        // 교체 대상 EnemyDataBlock 가져오기
                        var replacementEnemy = GameDataBlockBase<EnemyDataBlock>.GetBlock(replacementID);

                        if (replacementEnemy == null)
                        {
                            Plugin.Log.LogWarning(
                                $"교체 실패: ID={replacementID} 에 해당하는 EnemyDataBlock 을 찾을 수 없습니다. " +
                                $"EnemyIDs.cs 의 ID 값을 확인하세요."
                            );
                            continue;
                        }

                        Plugin.Log.LogInfo(
                            $"교체: [{block.name}] {entry.enemyType.name}(ID={originalID}) " +
                            $"→ {replacementEnemy.name}(ID={replacementID})"
                        );

                        entry.enemyType = replacementEnemy;
                        replacedCount++;
                    }
                }
            }

            Plugin.Log.LogInfo($"패치 완료: 총 {replacedCount}개 항목 교체됨.");
        }
    }
}
