using System.Collections.Generic;
using Core.Code.StorageObjects;
using Plugins.RobyyUtils;
using Unity.Mathematics;
using UnityEngine;

namespace Core.Code.LevelLogic
{
    public class LevelManager : Singleton<LevelManager>
    {
        [SerializeField] private List<Level> Levels;

        public void LoadNextLevel()
        {
            var levelStorageObject =
                PersistentStorage.PersistentStorage.Load<LevelStorageObject, LevelStorageObject.LevelData>(
                    new LevelStorageObject(new LevelStorageObject.LevelData(){LevelIndex = -1}));

            levelStorageObject.Data.LevelIndex += 1;
            
            if (levelStorageObject.Data.LevelIndex >= Levels.Count)
            {
                levelStorageObject.Data.LevelIndex = 0;
            }

            PersistentStorage.PersistentStorage.Save<LevelStorageObject, LevelStorageObject.LevelData>(
                levelStorageObject);
            
            var lvl = Instantiate(Levels[levelStorageObject.Data.LevelIndex], Vector3.zero, quaternion.identity)
                .GetComponent<Level>();
            
            lvl.Init();
        }
        
    }
}