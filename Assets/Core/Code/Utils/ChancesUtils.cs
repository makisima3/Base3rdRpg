using UnityEngine;

namespace Core.Code.Utils
{
    public static class ChancesUtils
    {
        public static bool CheckChance(float chance)
        {
            return Random.value <= chance;
        }
    }
}