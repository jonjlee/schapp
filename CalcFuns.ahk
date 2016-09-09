bmi(weightkg, heightmeters)
{
  return weightkg / (heightmeters * heightmeters)
}
mivf(kg)
{
  if (kg < 3.5) {
    return 4 * kg
  } else if (kg <= 10) {
    return (100 * kg) / 24
  } else if (kg <= 20) {
    return (1000 + 50 * (kg-10)) / 24
  } else {
    daily = (1500 + 20 * (kg-20))
    daily = daily > 2400 ? 2400 : daily
    return daily / 24
  }
}
kcal(cclast24hours,formulakcal,weight)
{
  return cclast24hours / weight * formulakcal / 30
}