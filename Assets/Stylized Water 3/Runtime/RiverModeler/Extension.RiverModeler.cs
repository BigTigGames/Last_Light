// Stylized Water 3 © Staggart Creations (http://staggart.xyz)
// COPYRIGHT PROTECTED UNDER THE UNITY ASSET STORE EULA (https://unity.com/legal/as-terms)
//
// ⚠️ WARNING: UNAUTHORIZED USE OR DISTRIBUTION IS STRICTLY PROHIBITED
// • Copying, referencing, or reverse-engineering this source code for the creation of new Asset Store or derivative products,
//   or any other publicly distributed content is strictly forbidden and will result in legal action.
// • Studying this file for the purpose of reproducing its functionality in your own assets or tools is not permitted.
// • If you are viewing this file as a reference, please close it immediately to avoid unintentional design influence or potential EULA violations.
// • Uploading this file or any derivative of it to a public GitHub or similar repository will trigger an automated DMCA takedown request.
// • Studying to understand for personal, educational or integration purposes is allowed, studying to reproduce is not.

#if !URP
#error River Modeler extension is imported without either the "Stylized Water 3" asset or the minimum "Universal Render Pipeline" version installed. Will not be functional until these are both installed and set up.
#endif

namespace StylizedWater3.RiverModeler
{
    public class RiverModelerExtension : Extension
    {
        public RiverModelerExtension()
        {
            this.id = ID.RiverModeler;
            this.name = "River Modeler";
            this.description = "Spline-based river mesh generation with VFX and audio streaming.";
            this.assetStoreID = 400836;
            docUrl = "https://staggart.xyz/unity/stylized-water-3/sw3-river-modeler-docs/";
            
            this.version = "1.0.1";
            this.minBaseVersion = "3.3.0";
            
            packageDependencies = new string[]
            {
                "com.unity.splines@2.8.3",
                "com.unity.visualeffectgraph",
            };

            demoScenes = new DemoScene[]
            {
                new DemoScene("f70056b9b1251d24fa940ecfac9e751b", "River Modeler Demo", "Complete river with cascades and branches"),
            };
        }

        public static RiverModelerExtension extension;

        public override void Load()
        {
            extension = IsInstalled(ID.RiverModeler) as RiverModelerExtension;
        }
    }
}