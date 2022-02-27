using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractiveRippleCtrl : MonoBehaviour
{
    private Material _material;
    public Camera cam;

    private Color previousColor;

    void Start()
    {
        var renderer = GetComponent<MeshRenderer>();
        _material = Instantiate(renderer.sharedMaterial);
        renderer.material = _material;

        previousColor = _material.GetColor("_BaseColor");
        _material.SetColor("_RippleColor", previousColor);
    }

    private void OnDestroy()
    {
        if (_material != null)
        {
            Destroy(_material);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            CastClickRay();
        }
    }

    private void CastClickRay()
    {
        //var camera = Camera.main;

        var mousePosition = Input.mousePosition;

        var ray = cam.ScreenPointToRay(new Vector3(mousePosition.x, mousePosition.y, cam.nearClipPlane));

        if (Physics.Raycast(ray, out var hit) && hit.collider.gameObject == gameObject)
        {
            StartRipple(hit.point);
        }
    }

    private void StartRipple(Vector3 center)
    {
        Color rippleColor = Color.HSVToRGB(Random.value, 1, 1);

        _material.SetVector("_RippleCenter", center);
        _material.SetFloat("_RippleStartTime", Time.time);

        _material.SetColor("_BaseColor", previousColor);
        _material.SetColor("_RippleColor", rippleColor);

        previousColor = rippleColor;
    }
}
