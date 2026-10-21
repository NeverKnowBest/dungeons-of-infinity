draw_set_color(c_grey);
draw_rectangle(BoxX, BoxY, BoxX + BoxW - 1, BoxY + BoxH - 1, false);

draw_set_color(c_white);
draw_set_font(fnt_header);

draw_text(BoxX + ((BoxW - MsgWidth) / 2), BoxY + 25, Msg);
