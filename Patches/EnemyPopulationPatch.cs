using GameData;
using HarmonyLib;

namespace BigEnemyMode.Patches
{
    [HarmonyPatch(typeof(GameDataInit), nameof(GameDataInit.Initialize))]
    internal static class EnemyPopulationPatch
    {
        [HarmonyPostfix]
        private static void Postfix()
        {
            Plugin.Log.LogInfo("EnemyPopulationDataBlock 패치 시작...");

            int replacedCount = 0;

            // 모든 EnemyPopulationDataBlock 순회
            foreach (var block in GameDataBlockBase<EnemyPopulationDataBlock>.GetAllBlocks())
            {
                // 현재 환경에서 가장 가능성 높은 이름인 m_roleList 시도
                if (block.m_roleList == null) continue;

                for (int i = 0; i < block.m_roleList.Count; i++)
                {
                    var entry = block.m_roleList[i];
                    
                    // 적 데이터를 참조하는 필드인 m_enemy 시도
                    uint originalID = entry.m_enemy.persistentID;

                    if (EnemyIDs.ReplacementMap.TryGetValue(originalID, out uint replacementID))
                    {
                        var replacementEnemy = GameDataBlockBase<EnemyDataBlock>.GetBlock(replacementID);

                        if (replacementEnemy == null)
                        {
                            Plugin.Log.LogWarning($"교체 실패: ID={replacementID} 에 해당하는 EnemyDataBlock 을 찾을 수 없습니다.");
                            continue;
                        }

                        Plugin.Log.LogInfo($"교체: [{block.name}] ID={originalID} → ID={replacementID}");

                        entry.m_enemy = replacementEnemy;
                        
                        // 변경된 구조체를 다시 리스트에 덮어쓰기 (안전한 반영을 위해 필수)
                        block.m_roleList[i] = entry;
                        replacedCount++;
                    }
                }
            }

            Plugin.Log.LogInfo($"패치 완료: 총 {replacedCount}개 항목 교체됨.");
        }
    }
}