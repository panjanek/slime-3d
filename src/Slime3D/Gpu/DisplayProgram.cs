using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenTK.GLControl;
using OpenTK.Graphics.OpenGL;
using OpenTK.Mathematics;
using Slime3D.Utils;

namespace Slime3D.Gpu
{
    public class DisplayProgram
    {
        private int program;

        private int projLocation;

        private int particleSizeLocation;

        private int fogDensityLocation;

        private int viewLocation;

        private int dummyVao;

        public DisplayProgram()
        {
            program = ShaderUtil.CompileAndLinkRenderShader("display.vert", "display.frag");
            projLocation = GL.GetUniformLocation(program, "projection");
            if (projLocation == -1) throw new Exception("Uniform 'projection' not found. Shader optimized it out?");
            particleSizeLocation = GL.GetUniformLocation(program, "particleSize");
            if (particleSizeLocation == -1) throw new Exception("Uniform 'particleSize' not found. Shader optimized it out?");
            fogDensityLocation = GL.GetUniformLocation(program, "fogDensity");
            if (fogDensityLocation == -1) throw new Exception("Uniform 'fogDensity' not found. Shader optimized it out?");
            viewLocation = GL.GetUniformLocation(program, "view");
            if (viewLocation == -1) throw new Exception("Uniform 'view' not found. Shader optimized it out?");

            dummyVao = GL.GenVertexArray();
            GL.BindVertexArray(0);
            GL.Enable(EnableCap.Multisample);
        }

        public void Run(Matrix4 projectionMatrix,
                       Matrix4 viewMatrix,
                       int particlesCount, 
                       float particleSize, 
                       float fogDensity)
        {
            GL.Enable(EnableCap.DepthTest);
            GL.DepthFunc(DepthFunction.Lequal);
            GL.DepthMask(true);
            GL.Clear(
                ClearBufferMask.ColorBufferBit |
                ClearBufferMask.DepthBufferBit
            );

            GL.Disable(EnableCap.Blend);
            GL.Enable(EnableCap.CullFace);
            GL.CullFace(CullFaceMode.Back);
            GL.FrontFace(FrontFaceDirection.Ccw);

            GL.UseProgram(program);
            GL.BindVertexArray(dummyVao);

            GL.UniformMatrix4(projLocation, false, ref projectionMatrix);
            GL.UniformMatrix4(viewLocation, false, ref viewMatrix);
            GL.Uniform1(particleSizeLocation, particleSize);
            GL.Uniform1(fogDensityLocation, fogDensity);

            GL.DrawArraysInstanced(
                PrimitiveType.Triangles,
                0,
                12, // vertices per tetrahedron
                particlesCount // number of particles
            );
        }
    }
}
