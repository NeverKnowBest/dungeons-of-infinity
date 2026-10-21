instance_create_layer(_SparklePosX[SparkleIndex], _SparklePosY[SparkleIndex], "Sparkles", oTitle_Sparkle);
SparkleIndex = (SparkleIndex + 1) mod 4;
alarm[5] = SparkleDelay;