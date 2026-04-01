using BepInEx;
using BepInEx.IL2CPP;
using BepInEx.Logging;
using HarmonyLib;

namespace BigEnemyMode
{
    [BepInPlugin(MyPluginInfo.PLUGIN_GUID, MyPluginInfo.PLUGIN_NAME, MyPluginInfo.PLUGIN_VERSION)]
    public class Plugin : BasePlugin
    {
        internal static ManualLogSource Log = null!;
        private Harmony? _harmony;

        public override void Load()
        {
            Log = base.Log;
            Log.LogInfo("BigEnemyMode 로드됨 - 스트라이커/슈터가 빅 버전으로 교체됩니다.");

            _harmony = new Harmony(MyPluginInfo.PLUGIN_GUID);
            _harmony.PatchAll();

            Log.LogInfo("패치 적용 완료.");
        }

        public override bool Unload()
        {
            _harmony?.UnpatchSelf();
            return base.Unload();
        }
    }
}
