using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour{
    
    private Vector3 lastPosition;
    private Vector3 positionOffset;
    private Quaternion rotationOffset;
    private Material material;
    private Quaternion lastRotation;

    // Start is called before the first frame update
    void Start(){
        
        material = GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update(){
        positionOffset = lastPosition - transform.position;
        rotationOffset = Quaternion.Inverse(lastRotation) * rotationOffset;
        material.SetVector("_OffsetPosition", positionOffset);
        lastPosition = Vector3.Lerp(lastPosition,transform.position,Time.deltaTime);
    }
}
