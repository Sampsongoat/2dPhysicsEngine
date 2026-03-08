# 🎱 2D Physics Engine

A real-time 2D physics simulation engine built from scratch in **C++** and **OpenGL** — no game engine, no physics library. Every system, from the batch renderer to collision resolution, is hand-rolled.

---

## 📸 Demo

> Click anywhere in the window to spawn physics objects. Watch them collide, bounce, and settle under gravity.

---

## ✨ Features

- **Batch Rendering** — All geometry is submitted in a single `glDrawElements` call per frame using a dynamic VAO/VBO/IBO pipeline
- **Shape Support** — Circles, squares, rectangles, ground planes, and walls
- **Impulse-Based Collision** — Physically accurate circle-circle and AABB-AABB collision resolution with overlap correction
- **Gravity & Bounce** — Configurable gravity, restitution coefficient, and velocity damping thresholds
- **Wall & Ground Collisions** — Axis-aligned boundary collision with per-side response and bounce falloff
- **Friction System** — Ground and contact friction applied per-frame based on surface contact state
- **Runtime Shader Compiler** — Parses vertex and fragment programs from a single unified `.shader` file at runtime
- **Aspect-Ratio Correction** — All physics boundaries and shape dimensions are corrected for screen aspect ratio, keeping behavior consistent at any resolution
- **Interactive Spawning** — Left-click anywhere to spawn a randomized object with unique size, color, and physics state

---

## 🏗️ Architecture

```
PhysicsEngine/
├── Physics/
│   └── PhysicsLayer.cpp       # Gravity, collision detection & resolution, friction
├── Rendering/
│   ├── Renderer.cpp           # Batch renderer (BeginBatch / DrawX / EndBatch)
│   ├── Shader.cpp             # Runtime shader parsing and compilation
│   ├── VertexArray.cpp        # VAO management
│   ├── VertexBuffer.cpp       # VBO management  
│   └── IndexBuffer.cpp        # IBO management
├── PhysicsRenderer.cpp        # Engine entry point, window/loop/input management
├── PhysicsEngine.cpp          # main()
└── res/
    └── shaders/
        └── Batch.shader       # Unified vertex + fragment shader
```

---

## ⚙️ How It Works

### Rendering Pipeline
The renderer uses a **batch rendering** strategy. Each frame:
1. `BeginBatch()` clears the vertex list
2. `DrawCircle()` / `DrawSquare()` / `DrawRectangle()` push vertices into a CPU-side buffer
3. `EndBatch()` uploads all vertices to the GPU in one `glBufferSubData` call and issues a single draw call

Circles are rendered as quads with a UV-based SDF circle shader, avoiding the need for actual polygon meshes.

### Physics Pipeline
Each frame, the physics layer:
1. Applies gravity to all dynamic shapes
2. Updates positions via Euler integration
3. Resolves ground and wall collisions with positional correction
4. Detects and resolves object-object collisions using impulse resolution
5. Applies friction based on ground contact and object proximity

### Collision Resolution
Circle collisions use **impulse-based resolution** with:
- Normalized collision normal from center-to-center vector
- Relative velocity projected onto the collision normal
- Impulse scaled by combined inverse mass and restitution coefficient
- Positional overlap correction to prevent tunneling

---

## 🔧 Dependencies

| Library | Purpose |
|--------|---------|
| [GLFW](https://www.glfw.org/) | Window creation, input handling |
| [GLAD](https://glad.dav1d.de/) | OpenGL function loader |
| OpenGL 3.3 Core | GPU rendering |

---

## 🚀 Building

### Prerequisites
- CMake 3.15+
- C++17 compiler (MSVC, GCC, or Clang)
- OpenGL 3.3 capable GPU

### Build Steps

```bash
git clone https://github.com/yourusername/2d-physics-engine.git
cd 2d-physics-engine
mkdir build && cd build
cmake ..
cmake --build . --config Release
```

### Run

```bash
./PhysicsEngine
```

> **Note:** The shader file must be located at `../../../res/shaders/Batch.shader` relative to the executable, or update the path in `Renderer.cpp`.

---

## 🎮 Controls

| Input | Action |
|-------|--------|
| Left Click | Spawn a physics object at cursor position |
| Close Window | Exit |

---

## 📐 Configuration

Key physics parameters are set in `PhysicsRenderer.cpp` during engine initialization:

```cpp
float gravity       = 0.01f;   // Downward acceleration per frame
float bounceLevel   = 0.5f;    // Restitution coefficient (0 = no bounce, 1 = perfect)
float groundWidth   = 2.95f;   // Width of the ground plane in NDC units
```

Restitution for object-object collisions is set in `PhysicsLayer.cpp`:
```cpp
m_Restitution = 0.7f;
```

---

## 🛠️ Known Limitations / Future Work

- [ ] No spatial partitioning (O(n²) collision checks — fine for hundreds of objects)
- [ ] `IsTouchingAnything` has an edge case that returns `true` for mixed shape types unconditionally
- [ ] No object removal / max object cap beyond `MaxQuads` renderer limit
- [ ] Add broad-phase collision culling (BVH or spatial grid) for larger simulations

---

## 📄 License

MIT License — feel free to use, fork, or learn from this project.
