namespace Core.Code.BuffSystem
{
    public interface IBuff<in TStats>
        where TStats: IStats
    {
        DurationType DurationType { get; }
        
        float Duration { get; }
        
        void Apply(TStats stats);
        
        void Reset(TStats stats);
    }
}