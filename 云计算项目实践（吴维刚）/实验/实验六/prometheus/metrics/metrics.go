package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
	"time"
    "math/rand"
)

var (
	requestCount = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name:      "request_total",
			Help:      "Number of request processed by this service.",
		}, []string{},
	)

	requestLatency = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:      "request_latency_seconds",
			Help:      "Time spent in this service.",
			Buckets:   []float64{0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 30.0, 60.0, 120.0, 300.0},
		}, []string{},
	)

    	cpuTemp = prometheus.NewGauge(
           	prometheus.GaugeOpts{
            	Name: "CPU_Temperature", 
            	Help: "temperature of CPU.", 
    	})

    	cpuUtil = prometheus.NewGauge(
        	prometheus.GaugeOpts{
            	Name: "CPU_Utilization", 
            	Help: "utilization of CPU.", 
    	})

    	memUtil = prometheus.NewGauge(
        	prometheus.GaugeOpts{
          	Name: "Memory_Utilization", 
           	Help: "utilization of memory.", 
    	})
)

// AdmissionLatency measures latency / execution time of Admission Control execution
// usual usage pattern is: timer := NewAdmissionLatency() ; compute ; timer.Observe()
type RequestLatency struct {
	histo *prometheus.HistogramVec
	start time.Time
}

func Register() {
	prometheus.MustRegister(requestCount)
	prometheus.MustRegister(requestLatency)
        prometheus.MustRegister(cpuTemp)
	prometheus.MustRegister(cpuUtil )
	prometheus.MustRegister(memUtil)
} 


// NewAdmissionLatency provides a timer for admission latency; call Observe() on it to measure
func NewAdmissionLatency() *RequestLatency {
	return &RequestLatency{
		histo: requestLatency,
		start: time.Now(),
	}
}

// Observe measures the execution time from when the AdmissionLatency was created
func (t *RequestLatency) Observe() {
	(*t.histo).WithLabelValues().Observe(time.Now().Sub(t.start).Seconds())
}


// RequestIncrease increases the counter of request handled by this service
func RequestIncrease() {
	requestCount.WithLabelValues().Add(1)
}

// Measurement of CPU temperature
func  MeasureTemperature() {
    	cpuTemp.Set(float64(rand.Int31n(30)+45))
}

// Measurement of CPU utilization and memory utilization
func  MeasureUtilization() {
    	cpuUtil.Set(float64(rand.Int31n(100)))
    	memUitl.Set(float64(rand.Int31n(100)))
}

