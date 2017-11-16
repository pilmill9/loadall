  
    
    
import schema namespace ty="http://tethys.sdsu.edu/schema/1.0" at "tethys.xsd";
<ty:Result xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
{
    
for $x in collection("detections")


 return 

 <out>
    {dbxml:metadata('dbxml:name', $x)}
 </out>
}
</ty:Result>