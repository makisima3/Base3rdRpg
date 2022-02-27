using System;
using PersistentStorage;
using UnityEngine;

namespace Core.Code.StorageObjects
{
    public class LevelStorageObject : PlainStorageObject<LevelStorageObject.LevelData>
    {
        [Serializable]
        public class LevelData
        {
            public int LevelIndex { get; set; } 
        }

        public LevelStorageObject(LevelData defaultData, Action<LevelData> afterLoading = null, Func<LevelData> beforeSaving = null) : base(defaultData, afterLoading, beforeSaving)
        {
        }

        public override string PrefKey => nameof(LevelStorageObject);
    }
}