varying lowp vec4 DestinationColor;

uniform highp vec2 startPosition;
uniform lowp vec4 clipPosition;
uniform sampler2D Texture;
uniform highp int drawMode;

varying lowp vec4 PositionOut;

varying lowp vec2 TexCoordOut;

/**
 *  RENDER_DRAW_NORMAL : 0
 *  RENDER_DRAW_TEXTURE : 1
 *  RENDER_DRAW_DASHED : 2
 */
void main(void) {
    
    if (PositionOut.x < clipPosition.x || PositionOut.x > clipPosition.z ||
        PositionOut.y > clipPosition.y || PositionOut.y < clipPosition.w) {
        gl_FragColor = vec4(0,0,0,0);
        return;
    }
    
    if(drawMode == 0) {
        gl_FragColor = DestinationColor;
    }else if(drawMode == 1) {
        gl_FragColor = texture2D(Texture, TexCoordOut);
    }else if(drawMode == 2) {
        if (mod(abs(distance(startPosition.xy, PositionOut.xy)) * 1000.0, 10.0) > 5.0) {
            gl_FragColor = vec4(0,0,0,0);
        }
        else
            gl_FragColor = DestinationColor;
    }
}