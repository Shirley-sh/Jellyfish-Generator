using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking.Match;

public class JellyfishGenerator : MonoBehaviour{
    // Start is called before the first frame update
    public GameObject jellyfish;
    
    [Header("Shape Body")]
    [Range(0,5)]public float rad;
    [Range(1,20)]public int subHeight;
    [Range(2,30)]public int numOfPatels;
    [Range(2,20)]public int axisPerPatel = 3;
    [Range(0f,1f)]public float cutAmount = 0.93f;
    [Range(0f,1f)]public float closeAmount = 0.2f;
    
    [Header("Shape Tentacle")]
    [Range(0f,20f)]public float tentacleLength = 0.3f;
    [Range(0f,1f)]public float tentacleWidth = 0.1f;
    [Range(0f,40f)]public int tentacleSubdivision = 10;
    [Range(0f, 1f)] public float tentacleOffset = 0;

    [Header("Material")] 
    public float patternFactor = -3.7f;
    
    [Header("Shape Body")]
    [Range(0,5)]public float radInner;
    [Range(1,20)]public int subHeightInner;
    [Range(2,30)]public int numOfPatelsInner;
    [Range(2,20)]public int axisPerPatelInner = 3;
    [Range(0f,1f)]public float cutAmountInner = 0.93f;
    [Range(0f,1f)]public float closeAmountInner = 0.2f;
    
    [Header("Shape Tentacle")]
    [Range(0f,20f)]public float tentacleLengthInner = 0.3f;
    [Range(0f,1f)]public float tentacleWidthInner = 0.1f;
    [Range(0f,40f)]public int tentacleSubdivisionInner = 10;
    [Range(0f, 1f)] public float tentacleOffsetInner = 0;

    [Header("Material")] 
    public float patternFactorInner = -3.7f;

    public void Generate() {
        GameObject newJellyfish = Instantiate(jellyfish);
        Camera.main.GetComponent<CameraFollow>().SetTarget(newJellyfish);
        Transform bellTransform = jellyfish.transform.GetChild(0);
        Transform gutsTransform = jellyfish.transform.GetChild(1);
        MeshGenerator bell = bellTransform.GetComponent<MeshGenerator>();
        MeshGenerator guts = gutsTransform.GetComponent<MeshGenerator>();
//        ( int _numOfPatels, float _cutAmount, float _closeAmount
//            , float _tentacleLength, float _tentacleWidth, float _tentacleOffset)
        Debug.Log(numOfPatels);
        bell.SetParameter(numOfPatels,cutAmount,closeAmount,
            tentacleLength,tentacleWidth,tentacleOffset);
        
        guts.SetParameter(4,0,closeAmountInner,
            tentacleLengthInner,tentacleWidthInner,tentacleOffsetInner);

        
    }
    

    public float Rad { get =>
        rad; set =>
            rad = value;
    }
    public int SubHeight { get =>
        subHeight; set =>
            subHeight = value;
    }
    public int NumOfPatels { get =>
        numOfPatels; set =>
            numOfPatels = value;
    }
    public int AxisPerPatel { get =>
        axisPerPatel; set =>
            axisPerPatel = value;
    }
    public float CutAmount { get =>
        cutAmount; set =>
            cutAmount = value;
    }
    public float CloseAmount { get =>
        closeAmount; set =>
            closeAmount = value;
    }
    public float TentacleLength { get =>
        tentacleLength; set =>
            tentacleLength = value;
    }
    public float TentacleWidth { get =>
        tentacleWidth; set =>
            tentacleWidth = value;
    }
    public int TentacleSubdivision { get =>
        tentacleSubdivision; set =>
            tentacleSubdivision = value;
    }
    public float TentacleOffset { get =>
        tentacleOffset; set =>
            tentacleOffset = value;
    }
    public float PatternFactor { get =>
        patternFactor; set =>
            patternFactor = value;
    }
    public float RadInner { get =>
        radInner; set =>
            radInner = value;
    }
    public int SubHeightInner { get =>
        subHeightInner; set =>
            subHeightInner = value;
    }
    public int NumOfPatelsInner { get =>
        numOfPatelsInner; set =>
            numOfPatelsInner = value;
    }
    public int AxisPerPatelInner { get =>
        axisPerPatelInner; set =>
            axisPerPatelInner = value;
    }
    public float CutAmountInner { get =>
        cutAmountInner; set =>
            cutAmountInner = value;
    }
    public float CloseAmountInner { get =>
        closeAmountInner; set =>
            closeAmountInner = value;
    }
    public float TentacleLengthInner { get =>
        tentacleLengthInner; set =>
            tentacleLengthInner = value;
    }
    public float TentacleWidthInner { get =>
        tentacleWidthInner; set =>
            tentacleWidthInner = value;
    }

    public int TentacleSubdivisionInner {
        get =>
            tentacleSubdivisionInner;
        set =>
            tentacleSubdivisionInner = value;
    }

    public float TentacleOffsetInner { get =>
        tentacleOffsetInner; set =>
            tentacleOffsetInner = value;
    }
    public float PatternFactorInner { get =>
        patternFactorInner; set =>
            patternFactorInner = value;
    }

    public void SetNumOfPatels(float num) { numOfPatels = (int) num; }

    public void Clear() {
        GameObject[] list = GameObject.FindGameObjectsWithTag("Jellyfish");
        foreach (GameObject jellyfish in list) {
            Destroy(jellyfish);
        }
        
    }
}
