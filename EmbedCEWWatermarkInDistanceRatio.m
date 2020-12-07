function [WatermarkedValue,EmbedWatermarkRecord] = EmbedCEWWatermarkInDistanceRatio(fileID,OriginalValue, EncryptStepLength, WatermarkStepLength,WatermarkSequence,WatermarkLength,EmbedWatermarkRecord)
    
    OriginalValue = log(OriginalValue);
    TempResidue = floor(OriginalValue/EncryptStepLength);
    temp = OriginalValue - TempResidue*EncryptStepLength;
    ValueForHash = round(double(temp*1e5))/1e5;
    MappedValue = floor(abs(LogiHash(ValueForHash)));
    MappedIndex = round(mod(MappedValue,WatermarkLength))+1;
    WatermarkBit = WatermarkSequence(MappedIndex);
    temp = temp - floor(temp/WatermarkStepLength)*WatermarkStepLength;
    temp = floor(temp/(WatermarkStepLength/2));
    WatermarkedValue = OriginalValue + (WatermarkBit - temp)*WatermarkStepLength/2;
    WatermarkedValue = exp(WatermarkedValue);
    EmbedWatermarkRecord(MappedIndex,WatermarkBit+1)=EmbedWatermarkRecord(MappedIndex,WatermarkBit + 1) + 1;
%     fprintf(fileID,'ValueForHash:%18.15f MappedValue:%18.15f MappedIndex:%18.15f WatermarkBit:%18.15f TempResidue:%18.15f WatermarkedValue:%18.15f\r\n',ValueForHash,MappedValue,MappedIndex,WatermarkBit,TempResidue,WatermarkedValue);
%     WatermarkedValue = OriginalValue;
end


