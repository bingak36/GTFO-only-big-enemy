using GameData;
using HarmonyLib;

namespace BigEnemyMode.Patches
{
    /// <summary>
    /// GameDataInit.Initialize() 완료 후 EnemyPopulationDataBlock의 RoleDatas를 순회하여
    /// 스트라이커/슈터 Enemy ID를 빅 버전으로 교체합니다.
    /// </summary>
    [HarmonyPatch(typeof(GameDataInit), "Initialize")]
    internal static class EnemyPopulationPatch
    {
        [HarmonyPostfix]
        private static void Postfix()
        {
            Plugin.Log.LogInfo("EnemyPopulationDataBlock 패치 시작...");
            int replacedCount = 0;

            foreach (var block in GameDataBlockBase<EnemyPopulationDataBlock>.GetAllBlocks())
            {
                foreach (var roleData in block.RoleDatas)
                {
                    uint originalID = roleData.Enemy;

                    if (!EnemyIDs.ReplacementMap.TryGetValue(originalID, out uint replacementID))
                        continue;

                    Plugin.Log.LogInfo(
                        $"[{block.name}] Enemy ID {originalID} → {replacementID}"
                    );
                    roleData.Enemy = replacementID;
                    replacedCount++;
                }
            }

            Plugin.Log.LogInfo($"패치 완료: {replacedCount}개 항목 교체됨.");
        }
    }
}
