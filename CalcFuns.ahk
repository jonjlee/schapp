bmi(weightkg, heightmeters)
{
  return weightkg / (heightmeters * heightmeters)
}
mivf(kg)
{
  rate = ""
  if (kg < 3.5) {
    rate := 4 * kg
  } else if (kg <= 10) {
    rate := (100 * kg) / 24
  } else if (kg <= 20) {
    rate := (1000 + 50 * (kg-10)) / 24
  } else {
    daily := (1500 + 20 * (kg-20))
    daily := daily > 2400 ? 2400 : daily
    rate := daily / 24
  }
  return rate . " mL/hr"
}
kcal(cclast24hours,formulakcal,weightkg)
{
  return (cclast24hours / weightkg * formulakcal / 30) . " mL/kg/d"
}
kg(kg) {
  lbsDecimal := kg * 2.2046
  lbs := Floor(lbsDecimal)
  oz := Round((lbsDecimal - lbs) * 16, 1)
  return kg . " kg = " . lbs . "lb " . oz . "oz"
}
lbs(lbs) {
  return lbs . " lbs = " . (lbs / 2.2046) . " kg"
}
t(deg) {
  return deg . "C=" . Round((deg * 1.8) + 32, 1) . "F and " . deg . "F=" . Round((deg - 32) / 1.8, 1) . "C"
}