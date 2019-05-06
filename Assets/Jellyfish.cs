using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Jellyfish: MonoBehaviour{

    
    
    void Start() {
        Rigidbody rb = GetComponent<Rigidbody>();
        Vector3 minPosition = new Vector3(-2,-2,0);
        Vector3 maxPosition = new Vector3(2,2,10);
        Vector3 force = new Vector3(Random.Range(minPosition.x, maxPosition.x), 
            Random.Range(minPosition.y, maxPosition.y), 
            Random.Range(minPosition.z, maxPosition.z) );
        rb.AddForce(force,ForceMode.Impulse);
    }
}
