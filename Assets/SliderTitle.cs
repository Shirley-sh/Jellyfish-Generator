using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class SliderTitle : MonoBehaviour
{
    // Start is called before the first frame update
    void Start(){
        TextMeshProUGUI textmeshPro = GetComponent<TextMeshProUGUI>();
        textmeshPro.SetText(transform.parent.name);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
