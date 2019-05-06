using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class SliderValue : MonoBehaviour {
    private TextMeshProUGUI text;

    private Slider slider;
    // Start is called before the first frame update
    void Start()
    {
        text = GetComponent<TextMeshProUGUI>();
        slider = transform.parent.GetComponent<Slider>();
    }

    // Update is called once per frame
    void Update() {
        
        text.SetText(slider.value.ToString("0.0"));
    }
}
