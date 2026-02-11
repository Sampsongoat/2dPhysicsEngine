#shader vertex
#version 330 core

layout(location = 0) in vec2 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec2 UV;
layout(location = 3) in float IsCircle;

out vec4 v_Color;
out vec2 v_UV;
out float v_IsCircle;

void main()
{
    v_Color = color;
    v_UV = UV;
    v_IsCircle = IsCircle;

    gl_Position = vec4(position, 0.0, 1.0);
}

#shader fragment
#version 330 core

layout(location = 0) out vec4 color;

in vec4 v_Color;
in vec2 v_UV;
in float v_IsCircle;

void main()
{
    if (v_IsCircle > 0.5)
    {
        vec2 center = vec2(0.5, 0.5);
        float distFromCenter = distance(v_UV, center);

        if (distFromCenter > 0.5)
        {
            discard;
        }

        float circleEdge = smoothstep(0.5, 0.48, distFromCenter);
        color = v_Color * vec4(1.0, 1.0, 1.0, circleEdge);
    }

    else
    {
        color = v_Color;
    }
}
