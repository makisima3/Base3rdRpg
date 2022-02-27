namespace Plugins.SimpleFactory
{
    public interface IInitialized<TInitData>
        where TInitData : class
    {
        void Initialize(TInitData initData);
    }
}