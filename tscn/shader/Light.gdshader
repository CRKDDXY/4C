shader_type canvas_item; // 用于2D场景

uniform vec4 glow_color = vec4(1.0, 1.0, 1.0, 1.0); // 辉光颜色
uniform float glow_strength : hint_range(0.0, 10.0) = 1.0; // 辉光强度
uniform float glow_radius : hint_range(0.0, 100.0) = 10.0; // 辉光范围

void fragment()
{
    // 获取基础颜色
    vec4 base_color = texture(TEXTURE, UV);

    // 计算辉光效果
    vec2 uv = UV;
    vec4 glow = vec4(0.0);
    for (float i = -glow_radius; i <= glow_radius; i += 1.0)
    {
        for (float j = -glow_radius; j <= glow_radius; j += 1.0)
        {
            vec2 offset = vec2(i, j) / vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y);
            vec4 sample_color = texture(TEXTURE, uv + offset);
            glow += sample_color * glow_strength;
        }
    }

    // 将辉光效果与基础颜色混合
    vec4 final_color = base_color + glow * glow_color;

    // 输出最终颜色
    COLOR = final_color;
}