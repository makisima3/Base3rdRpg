using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasCriticalDamageStat : IStats
    {
        float CriticalDamageMultiplier { get; set; }
        float BaseCriticalDamageMultiplier { get; }
    }
}