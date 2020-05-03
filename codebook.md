The contents of the measure.txt file are the following:

| Variable                     | Description                                                                                                                              |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| subject                      | The subject ID                                                                                                                           |
| activity                     | The type of activity the subject was performing                                                                                          |
| group                        | The type of group the subject was part of (train or test)                                                                                |
| domain                       | The domain of the measurement, either time or frequency based                                                                            |
| source                       | The source of the signal, either originated from body or gravity                                                                         |
| sensor                       | The sensor who originated the signal, either accelerometer or gyroscope                                                                  |
| type                         | The type of the measurement, either a mean or standard deviation                                                                         |
| axis                         | The axis x, y or z                                                                                                                       |
| magnitude                    | True if the observation is a magnitude, FALSE otherwise                                                                                  |
| jerk                         | True if the observation is a jerk signal, FALSE otherwise                                                                                |
| value                        | The mean body acceleration jerk measurement in standard gravity units (X axis)                                                           |
