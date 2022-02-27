using System;
using System.Linq;
using UnityEngine;

namespace Plugins.SimpleFactory
{
    public class SimpleFactory : MonoBehaviour
    {
        [SerializeField] private GameObject[] gameObjects;

        public GameObject Find<T>()
        {
            var result = gameObjects.FirstOrDefault(g => g.TryGetComponent<T>(out _));

            if (result == null)
                throw new Exception($"Object of type {typeof(T).Name} not found");

            return result;
        }

        public TObject Create<TObject, TInitData>(TInitData initData)
            where TObject : IInitialized<TInitData>
            where TInitData : class
        {
            var prefab = Find<TObject>();
            var instance = Instantiate(prefab).GetComponent<TObject>();
            
            instance.Initialize(initData);
            return instance;
        }
    }
}