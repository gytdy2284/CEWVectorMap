function [WatermarkBitIndex,WatermarkBit] = ExtractCEWWatermarkFromDistanceRatio(fileID,Value,EncryptStepLength,WatermarkStepLength,WatermarkLength)
    Value = log(Value);
    TempResidue = floor(Value/EncryptStepLength);
    temp = Value - TempResidue*EncryptStepLength;
    ValueForHash = round(double(temp*1e5))/1e5;
    MappedValue = floor(abs(LogiHash(ValueForHash)));
    WatermarkBitIndex = round(mod(MappedValue,WatermarkLength))+1;
    temp = temp - floor(temp/WatermarkStepLength)*WatermarkStepLength;
    WatermarkBit = floor(temp/(WatermarkStepLength/2));
%     fprintf(fileID,'ValueForHash:%18.15f MappedValue:%18.15f WatermarkBitIndex:%18.15f TempResidue:%18.15f WatermarkBit:%18.15f \r\n',ValueForHash,MappedValue,WatermarkBitIndex,temp,WatermarkBit);
end

