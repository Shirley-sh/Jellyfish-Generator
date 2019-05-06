using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NaughtyAttributes;
using UnityEngine.Experimental.UIElements;

public class MeshGenerator : MonoBehaviour {
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



    private bool isInitialized;
    private MeshFilter meshFilter;
    private Mesh mesh;
    private Material material;

    private int subAxis;
    private Vector3 lastPosition;
    private Vector3 positionOffset;
    
    private List<Vector3> vertices;
    private List<int> triangles;
    private List<Vector2> uvs;
    private List<Vector3> colors;

    public void SetParameter( int _numOfPatels, float _cutAmount, float _closeAmount
        , float _tentacleLength, float _tentacleWidth, float _tentacleOffset) {
        rad = 1;
        subHeight = 10;
        numOfPatels = _numOfPatels;
        axisPerPatel = 5;
        cutAmount = _cutAmount;
        closeAmount = _closeAmount;
        tentacleLength = _tentacleLength;
        tentacleWidth = _tentacleWidth;
        tentacleSubdivision = (int)_tentacleLength*10;
        tentacleOffset = _tentacleOffset;
        patternFactor = Random.Range(-10f,10f);
        Debug.Log("Set Para");
        isInitialized = true;
    }

    [Button()]
    public void Generate() {
        Debug.Log("Generate");
        meshFilter = GetComponent<MeshFilter>();
        material = GetComponent<Renderer>().material;
        
        material.SetFloat("_PatternFactor", patternFactor);
        material.SetFloat("_TentacleLength", tentacleLength);
        
        vertices = new List<Vector3>();
        triangles = new List<int>();
        uvs = new List<Vector2>();
        colors = new List<Vector3>();
        
        subAxis= numOfPatels * axisPerPatel;
        
        //origin
        vertices.Add(Vector3.zero);
        uvs.Add(new Vector2(0.5f,0.5f));
        //head
        for (int heightIndex = 1; heightIndex < subHeight; heightIndex++) {
            for (int axisIndex = 0; axisIndex < subAxis; axisIndex++) {
                Vector3 pos = GetPosBySubdivision(axisIndex, heightIndex);
                vertices.Add(pos);
                
                uvs.Add(new Vector2(pos.x/rad*0.5f+0.5f,pos.z/rad*0.5f+0.5f));
            }
        }
        for (int heightIndex = 0; heightIndex < subHeight-1; heightIndex++) {
            for (int axisIndex = 0; axisIndex < subAxis; axisIndex++) {
                if (heightIndex == 0) {
                    AddToTriangle(0,axisIndex+1,axisIndex == subAxis-1? 1: axisIndex+1+1);
                } else if(axisIndex != subAxis){
                    int i0 = GetIndexBySubdivision(axisIndex,heightIndex-1);
                    int i1 = GetIndexBySubdivision(axisIndex, heightIndex);
                    int i2 = axisIndex == subAxis-1?
                        GetIndexBySubdivision(0, heightIndex):GetIndexBySubdivision(axisIndex+1, heightIndex);
                    int i3 = axisIndex == subAxis-1?
                        GetIndexBySubdivision(0,heightIndex-1):GetIndexBySubdivision(axisIndex+1,heightIndex-1);
                    AddToTriangle(i0, i1, i2);
                    AddToTriangle(i0, i2, i3);
                }
            }
        }
        //tentacles
        float tentacleSegmentLength = tentacleLength / tentacleSubdivision;
        float tentacleRad = rad *( 1 - tentacleOffset);
        for (int axisIndex = 0; axisIndex < subAxis; axisIndex++) {
            for (int i = 0; i < tentacleSubdivision; i++) {
                Vector3 l1, l2, r1, r2;
                int i0, i1, i2, i3;
                if (i == 0) {
                    l1 = GetPosBySubdivision(axisIndex + tentacleWidth, subHeight-1);
                    l1.y += 0.01f;

                    r1 = GetPosBySubdivision(axisIndex - tentacleWidth, subHeight-1);
                    r1.y += 0.01f;
                    
                } else {
                    l1 = GetTentaclePosBySubdivision(axisIndex + tentacleWidth, subHeight);
                    l1.y -= -tentacleSegmentLength + i * tentacleSegmentLength;

                    r1 = GetTentaclePosBySubdivision(axisIndex - tentacleWidth, subHeight);
                    r1.y -= -tentacleSegmentLength + i * tentacleSegmentLength;
                }
                
                vertices.Add(l1);
                uvs.Add(new Vector2(l1.x / tentacleRad * 0.5f + 0.5f, l1.z / tentacleRad * 0.5f + 0.5f));
                i0 = vertices.Count - 1;
                vertices.Add(r1);
                uvs.Add(new Vector2(r1.x / tentacleRad * 0.5f + 0.5f, r1.z / tentacleRad * 0.5f + 0.5f));
                i1 = vertices.Count - 1;


                r2 = GetTentaclePosBySubdivision(axisIndex-tentacleWidth, subHeight);
                r2.y -= i * tentacleSegmentLength;
                vertices.Add(r2);
                uvs.Add(new Vector2(r2.x/tentacleRad*0.5f+0.5f,r2.z/tentacleRad*0.5f+0.5f));
                i2 = vertices.Count - 1;
                
                l2 = GetTentaclePosBySubdivision(axisIndex+tentacleWidth, subHeight);
                l2.y -= i * tentacleSegmentLength;
                vertices.Add(l2);
                uvs.Add(new Vector2(l2.x/tentacleRad*0.5f+0.5f,l2.z/tentacleRad*0.5f+0.5f));
                i3 = vertices.Count - 1;
                AddToTriangle(i0, i1, i2);
                AddToTriangle(i0, i2, i3);
            }
  
        }

        
        meshFilter.sharedMesh = CreateMesh();
        isInitialized = true;


    }

    Vector3 GetPosBySubdivision(float axisIndex, float heightIndex) {
        float x, y, z;
        y = rad * (1 - Mathf.Cos(heightIndex * Mathf.PI * 0.5f / subHeight));
        y*=1+Mathf.Abs(Mathf.Sin(Mathf.PI/axisPerPatel*axisIndex))*cutAmount;
            
        float r = Mathf.Sqrt(rad * rad - (rad-y) * (rad-y));
        r *= 1 - closeAmount * Mathf.Pow(Mathf.Abs(y),2);
        r += Mathf.Abs(Mathf.Sin(Mathf.PI/axisPerPatel*axisIndex))*cutAmount*Mathf.Pow(y,4);
        x = Mathf.Sin(axisIndex * Mathf.PI*2 / subAxis)*r;
        z = Mathf.Cos(axisIndex * Mathf.PI*2 / subAxis)*r;
        return new Vector3(x,-y,z);
        
    }
    
    Vector3 GetTentaclePosBySubdivision(float axisIndex, float heightIndex) {
        float x, y, z;
        y = rad * (1 - Mathf.Cos(heightIndex * Mathf.PI * 0.5f / subHeight));
            
        float r = Mathf.Sqrt(rad * rad - (rad-y) * (rad-y));
        r *= 1 - closeAmount * Mathf.Pow(Mathf.Abs(y),2);
        r += Mathf.Abs(Mathf.Sin(Mathf.PI/axisPerPatel*axisIndex))*cutAmount*Mathf.Pow(y,4);
        x = Mathf.Sin(axisIndex * Mathf.PI*2 / subAxis)*r;
        z = Mathf.Cos(axisIndex * Mathf.PI*2 / subAxis)*r;
        return new Vector3(x,-y,z);
        
    }
    
    int GetIndexBySubdivision(int axisIndex, int heightIndex) {
        return axisIndex + heightIndex*subAxis+1;
        
    }
    
    public void AddToTriangle(int index0, int index1, int index2){
        triangles.Add(index0);
        triangles.Add(index1);
        triangles.Add(index2);
    }
    
    public Mesh CreateMesh(){
        if(mesh!=null)mesh.Clear();
        mesh = new Mesh();
        
        mesh.vertices = vertices.ToArray();
        mesh.triangles = triangles.ToArray();

        //UVs are optional. Only use them if we have the correct amount:
        if (uvs.Count == vertices.Count)
            mesh.uv = uvs.ToArray();

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.MarkDynamic();
        return mesh;
    }

    
    // Update is called once per frame
    void Update() {
        if (isInitialized) {
            positionOffset = lastPosition - transform.position;
            material.SetVector("_DampOffset", positionOffset);
            lastPosition = Vector3.Lerp(lastPosition, transform.position, Time.deltaTime * 0.3f);
        } else {
            Generate();
        }
    }
    
    public void UpdateMesh() {

        mesh.vertices = vertices.ToArray();
        mesh.triangles = triangles.ToArray();

        //UVs are optional. Only use them if we have the correct amount:
        if (uvs.Count == vertices.Count)
            mesh.uv = uvs.ToArray();

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
    }
}
