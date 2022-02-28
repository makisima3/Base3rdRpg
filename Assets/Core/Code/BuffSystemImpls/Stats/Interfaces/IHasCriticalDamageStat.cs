using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasCriticalDamageStat : IStats
    {
        float CriticalDamageMultipler { get; set; }
        float BaseCriticalDamageMultipler { get; }
    }
}