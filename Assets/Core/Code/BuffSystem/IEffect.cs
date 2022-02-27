namespace Core.Code.BuffSystem
{
    public interface IEffect<in TStats, in TBuff>
        where TStats : IStats
        where TBuff : IBuff<TStats>
    {
        void Activate(TStats stats, TBuff buff);
    }
}