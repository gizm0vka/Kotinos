/*  
Paddle Design using Bezier Surface. 
 */ 

// enter your hand param 
include <BOSL2/std.scad>
include <BOSL2/beziers.scad>


function matrixPerimeter(Mat) = let(row=len(Mat), col=len(Mat[0])) concat(  
   Mat[0], //1st row
   slice(column(Mat,col-1), 1, row), //last col 
   select(Mat[row-1], count(col-1, 0, reverse=true)), //flipped last row
   select(column(Mat,0), count(row-2,1,reverse=true)) //flipped 1st col
);

function innerPerimeter(Mat) = let(row=len(Mat), col=len(Mat[0])) concat( //assume n>4
    select(Mat[1], concat(1,count(col-2,1),col-2)), //1st inner rows
    select(column(Mat, col-2), concat(count(row-2,1),row-2)),
    select(Mat[row-2], concat(count(col-2,1,reverse=true),1)), //Last inner rows
    select(column(Mat, 1), count(row-2,1,reverse=true)) //inner 1st column
);
function averageTriplet(arry) = let(tri=triplet(arry, wrap=true)) [for(i=idx(tri)) mean(tri[i])];

function tangentPerimeter(Mat, a=1) = 
  let(unitTangentPerimeter = [for(i=idx(matrixPerimeter(Mat)))unit((matrixPerimeter(Mat)-innerPerimeter(Mat))[i])])
  a*unitTangentPerimeter+matrixPerimeter(Mat);
  
//function normalProjection(patch, n, a=1) = let(uv= lerpn(0,1,n+1))bezier_patch_points((patch), uv, uv)- a*bezier_patch_normals(patch, uv, uv);

function VPatch (patch) = [for(i=[0:len(patch)-2]) [for(l=[0:len(patch[0])-1]) default(patch[i+1][l],[0,0,0])-default(patch[i][l],[0,0,0])]]; //Vertical segment vectors
function HPatch (patch) = [for(i=[0:len(patch)-1]) [for(l=[0:len(patch[0])-2]) default(patch[i][l+1],[0,0,0])-default(patch[i][l],[0,0,0])]]; //Horizontal segment vectors
function CPatch (patch) = let(mrow= len(patch)-1, mcol=len(patch[0])-1) //Corner patch for more accurate corner vertex normals
                           [[patch[1][1]-patch[0][0], patch[1][mcol-1]-patch[0][mcol]], 
                           [patch[mrow-1][1]-patch[mrow][0], (patch[mrow-1][mcol-1]-patch[mrow][mcol])]];


function vertexCornerNormal(patch, a=1) = let(row = len(patch)-1, col= len(patch[0])-1) // special case for corner for smoother normal projection
  a*[
    [let(i=0,j=0)unit(cross(HPatch(patch)[i][j], CPatch(patch)[0][0])+cross(VPatch(patch)[i][j], -CPatch(patch)[0][0])),
     let(i=0,j=col)unit(cross(HPatch(patch)[i][j-1], CPatch(patch)[0][1])+cross(VPatch(patch)[i][j],   CPatch(patch)[0][1]))],
    [let(i=row,j=0)unit(cross(HPatch(patch)[i][j], -CPatch(patch)[1][0])+cross(VPatch(patch)[i-1][j],-CPatch(patch)[1][0])),
     let(i=row,j=col)unit(cross(HPatch(patch)[i][j-1], -CPatch(patch)[1][1])+cross(VPatch(patch)[i-1][j], CPatch(patch)[1][1]))]
  ];
  
function projectVertexNormal(patch, a=1) = 
  let(H=HPatch(patch),V=VPatch(patch), C=vertexCornerNormal(patch, a), row = len(patch), col= len(patch[0])) 
    [for(i=count(row))
      [for(j=count(col)) ((j!=0 && j!=col-1) || (i!=0 && i!=row-1)) ? patch[i][j]+a*unit(sum([for(l=count(2,i-1), k=count(2,j-1)) cross(default(H[i][k],[0,0,0]),default(V[l][j],[0,0,0]))]))
      : patch[i][j]+C[min(i,1)][min(j,1)]]
    ];//take vector list and apply 

module bezSheetStitching (patch, normal_thickness=1, tangent_thickness=1, splinesteps, Preview=false) {
  l_row=len(patch);
  l_col=len(patch[0]);
  
  TopNormalPatch = projectVertexNormal(patch = patch, a=normal_thickness);
  BottomTangentPatch = tangentPerimeter(Mat = patch, a = tangent_thickness);
  TopTangentPatch = tangentPerimeter(projectVertexNormal(patch = patch, a=normal_thickness),tangent_thickness);
  
  patchPerimeterEdge = let(ct=l_col, st=0 )[select(matrixPerimeter(patch), count(ct,st)),select(BottomTangentPatch, count(ct,st)),select(TopTangentPatch, count(ct,st)),select(matrixPerimeter(TopNormalPatch), count(ct,st))];
  patchPerimeterEdge2 = let(ct=l_row, st=l_col-1)[select(matrixPerimeter(patch), count(ct,st)),select(BottomTangentPatch, count(ct,st)),select(TopTangentPatch, count(ct,st)),select(matrixPerimeter(TopNormalPatch), count(ct,st))];  
  patchPerimeterEdge3 = let(ct=l_col, st=l_row+l_col-2 )[select(matrixPerimeter(patch), count(ct,st)), select(BottomTangentPatch, count(ct,st)),select(TopTangentPatch, count(ct,st)),select(matrixPerimeter(TopNormalPatch), count(ct,st))];
  patchPerimeterEdge4 = let(ct=l_row, st=l_row+l_col*2-3 )[select(matrixPerimeter(patch),count(ct,st)),select(BottomTangentPatch, count(ct,st)),select(TopTangentPatch, count(ct,st)),select(matrixPerimeter(TopNormalPatch), count(ct,st))];
  //generation part

  if(Preview==true){
    debug_bezier_patches(patches=[TopNormalPatch], size=1, showcps=true);
    rainbow(BottomTangentPatch)move($item)sphere();

  } else {
   vnf_polyhedron(
      vnf_join(
           [bezier_vnf(patches=bezier_patch_reverse(patch), splinesteps=splinesteps),
            bezier_vnf(patches=[patchPerimeterEdge],  splinesteps=splinesteps),
            bezier_vnf(patches=[patchPerimeterEdge2], splinesteps=splinesteps),
            bezier_vnf(patches=[patchPerimeterEdge3], splinesteps=splinesteps),
            bezier_vnf(patches=[patchPerimeterEdge4], splinesteps=splinesteps),
            bezier_vnf(patches=[TopNormalPatch], splinesteps=splinesteps)]
      )
   );
 }
//   vnf_validate(bezier_vnf(patches=[TopNormalPatch]), size=.1);

 }; //generate perimeter stich bez structure by extending a patch my normal in scalar, rounded by


              
function EdgePatching (Patch) = [for(n=count(Patch))
                                  [for(m=count(Patch[n]))
                                    n==0 && m==0 ? mean([Patch[0][1],Patch[1][0]]) : 
                                    n==0 && m==len(Patch[n])-1 ? mean([Patch[0][m-1],Patch[1][m]]) :
                                    n==len(Patch)-1 && m==0 ? mean([Patch[n-1][0],Patch[n][1]]) :
                                    n==len(Patch)-1 && m==len(Patch[n])-1 ? mean([Patch[n-1][m],Patch[n][m-1]]) :
                                    Patch[n][m]
                                  ]]; 

 module PatchPaddle (Patch, debug =false, thick=1.5 ) {
  PaddlePatch = EdgePatching(Patch);
  splineSize = 24;
  bezSheetStitching(patch = PaddlePatch, normal_thickness=thick, tangent_thickness=1, splinesteps=splineSize, Preview=debug);
 }
 
