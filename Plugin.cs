using BepInEx;
using BepInEx.Unity.IL2CPP;
using BepInEx.Logging;
using HarmonyLib;

namespace BigEnemyMode
{
    [BepInPlugin(MyPluginInfo.PLUGIN_GUID, MyPluginInfo.PLUGIN_NAME, MyPluginInfo.PLUGIN_VERSION)]
    [BepInProcess("GTFO.exe")]
    public class Plugin : BasePlugin
    {
        internal static new ManualLogSource Log = null!;
        private Harmony? _harmony;

        public override void Load()
        {
            Log = base.Log;
            Log.LogInfo($"{MyPluginInfo.PLUGIN_NAME} v{MyPluginInfo.PLUGIN_VERSION} 로드됨");
            Log.LogInfo("스트라이커 → 빅 스트라이커, 슈터 → 빅 슈터로 교체됩니다.");

            _harmony = new Harmony(MyPluginInfo.PLUGIN_GUID);
            _harmony.PatchAll();

            Log.LogInfo("패치 적용 완료.");
        }

        public override bool Unload()
        {
            _harmony?.UnpatchSelf();
            Log.LogInfo($"{MyPluginInfo.PLUGIN_NAME} 언로드됨.");
            return base.Unload();
        }
    }
}
