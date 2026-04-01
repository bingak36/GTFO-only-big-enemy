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
                for (int i = 0; i < block.m_population.Count; i++) 
{
    var entry = block.m_population[i];
    uint originalID = entry.enemyType.persistentID;

    if (EnemyIDs.ReplacementMap.TryGetValue(originalID, out uint replacementID))
    {
        var replacementEnemy = GameDataBlockBase<EnemyDataBlock>.GetBlock(replacementID);
        if (replacementEnemy != null)
        {
            Plugin.Log.LogInfo($"교체: [{block.name}] ID={originalID} → ID={replacementID}");
            entry.enemyType = replacementEnemy;
            
            // 구조체일 경우를 대비하여 원본 리스트/배열에 다시 덮어쓰기
            block.m_population[i] = entry; 
            replacedCount++;
        }
    }
}
            }

            Plugin.Log.LogInfo($"패치 완료: 총 {replacedCount}개 항목 교체됨.");
        }
    }
}
