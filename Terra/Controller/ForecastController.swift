//
//  ForecastController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 19/05/22.
//

import UIKit
import SwiftCharts


private extension UIColor {
    //static let secondaryLabelColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
    static let secondaryLabelColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    
    
    //static let gridColor = UIColor(white: 193 / 255, alpha: 1)
    static let gridColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    static let glucoseTintColor = #colorLiteral(red: 0.7803921569, green: 0.03921568627, blue: 0.5019607843, alpha: 1)

    
    //static let glucoseTintColor = UIColor(red: 96 / 255, green: 201 / 255, blue: 248 / 255, alpha: 1)

    //static let IOBTintColor: UIColor = UIColor(red: 254 / 255, green: 149 / 255, blue: 138 / 255, alpha: 1)
    static let IOBTintColor: UIColor = #colorLiteral(red: 0.3490196078, green: 0.02352941176, blue: 0.5882352941, alpha: 1)
}

private let dateFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .short
    timeFormatter.timeStyle = .short
    
    return timeFormatter
}()

private let localDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = K.Chart.dateFormat
    dateFormatter.locale = Locale(identifier: K.Chart.dateFormatLocale)
    
    return dateFormatter
}()

private let decimalFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2

    return numberFormatter
}()

private let axisLabelSettings: ChartLabelSettings = ChartLabelSettings()

class ForecastController: UIViewController, UIGestureRecognizerDelegate {
    
    var pointsClouds = [chartPoints]()
    var pointsTemp = [chartPoints]()
    fileprivate var topChart: Chart?
    fileprivate var bottomChart: Chart?
    
    fileprivate lazy private(set) var chartLongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    // MARK: – Chart configuration
    
    fileprivate lazy private(set) var chartSettings: ChartSettings = {
        var chartSettings = ChartSettings()
        chartSettings.top = 12
        chartSettings.bottom = 12
        chartSettings.trailing = 8
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.labelsToAxisSpacingX = 6
        chartSettings.clipInnerFrame = false
        return chartSettings
    }()
    
    private let guideLinesLayerSettings: ChartGuideLinesLayerSettings = ChartGuideLinesLayerSettings()
    
    fileprivate lazy private(set) var axisLineColor = UIColor.clear
    
    let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
    
    fileprivate var xAxisValues: [ChartAxisValue]? {
        didSet {
            if let xAxisValues = xAxisValues {
                
                xAxisModel = ChartAxisModel(axisValues: xAxisValues, lineColor: axisLineColor, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings), labelSpaceReservationMode: .fixed(20))
                
                
            } else {
                xAxisModel = nil
            }
        }
    }
    
    fileprivate var xAxisModel: ChartAxisModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        chartLongPressGestureRecognizer.delegate = self
        chartLongPressGestureRecognizer.minimumPressDuration = 0.01
        view.addGestureRecognizer(chartLongPressGestureRecognizer)
        
        if(pointsTemp.count > 0 && pointsTemp.count > 0)
        {
            generateXAxisValues()
        }
        
        let fullFrame = ChartDefaults.chartFrame(view.bounds)
        let (topFrame, bottomFrame) = fullFrame.divided(atDistance: fullFrame.height / 2, from: .minYEdge)

        if(pointsTemp.count > 0 && pointsTemp.count > 0)
        {
            topChart = generateGlucoseChartWithFrame(topFrame)
            bottomChart = generateIOBChartWithFrame(frame: bottomFrame)
        }
        
        for chart in [topChart, bottomChart] {
            if let view = chart?.view {
                self.view.addSubview(view)
            }
        }
        
    }
    
    fileprivate func generateXAxisValues() {
        

        let points = pointsTemp.map{
            return ChartPoint(
                x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.date)!, formatter: dateFormatter),
                y: ChartAxisValueInt(Int($0.point))
                )
            }
        
        guard points.count > 1 else {
            self.xAxisValues = []
            return
        }

        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = K.Chart.xAxisDateFormat   //"h a"
        
        let xAxisValues = ChartAxisValuesStaticGenerator.generateXAxisValuesWithChartPoints(points, minSegmentCount: 5, maxSegmentCount: 10, multiple: TimeInterval(60 * 60), axisValueGenerator: { ChartAxisValueDate(date: ChartAxisValueDate.dateFromScalar($0), formatter: timeFormatter, labelSettings: axisLabelSettings)
            }, addPaddingSegmentIfEdge: false)
        xAxisValues.first?.hidden = true
        xAxisValues.last?.hidden = true

        self.xAxisValues = xAxisValues
    }
    
    fileprivate func generateGlucoseChartWithFrame(_ frame: CGRect) -> Chart? {
        let glucosePoints = pointsTemp.map{
            return ChartPoint(

                x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.date)!, formatter: dateFormatter),
                y: ChartAxisValueDouble($0.point, formatter: decimalFormatter)
            )
        }
        
        
        guard glucosePoints.count > 1, let xAxisValues = xAxisValues, let xAxisModel = xAxisModel else {
            return nil
        }

        let allPoints = glucosePoints
        
        // TODO: The segment/multiple values are unit-specific
        let yAxisValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(allPoints, minSegmentCount: 2, maxSegmentCount: 4, multiple: 25, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: axisLabelSettings)}, addPaddingSegmentIfEdge: true)

        let yAxisModel = ChartAxisModel(axisValues: yAxisValues, lineColor: axisLineColor, axisTitleLabel: ChartAxisLabel(text: K.Chart.yAxisTextChart1, settings: labelSettings.defaultVertical()), labelSpaceReservationMode: .fixed(30))
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xAxisModel, yModel: yAxisModel)

        let (xAxisLayer, yAxisLayer) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer)

        let gridLayer = ChartGuideLinesForValuesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, settings: guideLinesLayerSettings, axisValuesX: Array(xAxisValues.dropLast(1)), axisValuesY: [])

        let circles = ChartPointsScatterCirclesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: glucosePoints, displayDelay: 0, itemSize: CGSize(width: 8, height: 8), itemFillColor: UIColor.glucoseTintColor)


        let highlightLayer = ChartPointsTouchHighlightLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            chartPoints: allPoints,
            tintColor: UIColor.glucoseTintColor,
            labelCenterY: chartSettings.top,
            gestureRecognizer: chartLongPressGestureRecognizer,
            onCompleteHighlight: nil
        )

        let layers: [ChartLayer?] = [
            gridLayer,
            xAxisLayer,
            yAxisLayer,
            highlightLayer,
            circles
        ]
        
        return Chart(frame: frame, innerFrame: coordsSpace.chartInnerFrame, settings: chartSettings, layers: layers.compactMap { $0 })
    }

    private func generateIOBChartWithFrame(frame: CGRect) -> Chart? {
        
        let IOBPoints = pointsClouds.map{
            return ChartPoint(
                x: ChartAxisValueDate(date: localDateFormatter.date(from: $0.date)!, formatter: dateFormatter),
                y: ChartAxisValueInt(Int($0.point))
                )
            }
        
        guard IOBPoints.count > 1, let xAxisValues = xAxisValues, let xAxisModel = xAxisModel else {
            return nil
        }

        var containerPoints = IOBPoints
        
        
        // Create a container line at 0
        if let first = IOBPoints.first {
            containerPoints.insert(ChartPoint(x: first.x, y: ChartAxisValueInt(0)), at: 0)
        }

        if let last = IOBPoints.last {
            containerPoints.append(ChartPoint(x: last.x, y: ChartAxisValueInt(0)))
        }

        let yAxisValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(IOBPoints, minSegmentCount: 2, maxSegmentCount: 3, multiple: 0.5, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: axisLabelSettings)}, addPaddingSegmentIfEdge: false)

        let yAxisModel = ChartAxisModel(axisValues: yAxisValues, lineColor: axisLineColor, axisTitleLabel: ChartAxisLabel(text: K.Chart.yAxisTextChart2, settings: labelSettings.defaultVertical()), labelSpaceReservationMode: .fixed(30))
        
    

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: frame, xModel: xAxisModel, yModel: yAxisModel)

        let (xAxisLayer, yAxisLayer) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer)
        let (xAxis, yAxis) = (xAxisLayer.axis, yAxisLayer.axis)

        // The IOB area
        let lineModel = ChartLineModel(chartPoints: IOBPoints, lineColor: UIColor.IOBTintColor, lineWidth: 2, animDuration: 0, animDelay: 0)
        let IOBLine = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, lineModels: [lineModel], pathGenerator: StraightLinePathGenerator())
        
        let IOBArea = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: containerPoints, areaColors: [UIColor.IOBTintColor.withAlphaComponent(0.75), UIColor.clear], animDuration: 0, animDelay: 0, addContainerPoints: false, pathGenerator: IOBLine.pathGenerator)
        
        // Grid lines
        let gridLayer = ChartGuideLinesForValuesLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, settings: guideLinesLayerSettings, axisValuesX: Array(xAxisValues.dropLast(1)), axisValuesY: yAxisValues)

        // 0-line
        let dummyZeroChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let zeroGuidelineLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, chartPoints: [dummyZeroChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let width: CGFloat = 0.5
            let viewFrame = CGRect(x: chart.contentView.bounds.minX, y: chartPointModel.screenLoc.y - width / 2, width: chart.contentView.bounds.size.width, height: width)

            let v = UIView(frame: viewFrame)
            v.backgroundColor = UIColor.IOBTintColor
            return v
        })

        let highlightLayer = ChartPointsTouchHighlightLayer(
            xAxisLayer: xAxisLayer,
            yAxisLayer: yAxisLayer,
            chartPoints: IOBPoints,
            tintColor: UIColor.IOBTintColor,
            labelCenterY: chartSettings.top,
            gestureRecognizer: chartLongPressGestureRecognizer,
            onCompleteHighlight: nil
        )

        let layers: [ChartLayer?] = [
            gridLayer,
            xAxisLayer,
            yAxisLayer,
            zeroGuidelineLayer,
            highlightLayer,
            IOBArea,
            IOBLine,
        ]

        return Chart(frame: frame, innerFrame: coordsSpace.chartInnerFrame, settings: chartSettings, layers: layers.compactMap { $0 })
    }
    
}

/*
 Here we extend ChartPointsTouchHighlightLayer to contain its initialization
 */
private extension ChartPointsTouchHighlightLayer {

    convenience init(
        xAxisLayer: ChartAxisLayer,
        yAxisLayer: ChartAxisLayer,
        chartPoints: [T],
        tintColor: UIColor,
        labelCenterY: CGFloat = 0,
        gestureRecognizer: UILongPressGestureRecognizer? = nil,
        onCompleteHighlight: (()->Void)? = nil
    ) {
        self.init(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, gestureRecognizer: gestureRecognizer, onCompleteHighlight: onCompleteHighlight,
                  modelFilter: { (screenLoc, chartPointModels) -> ChartPointLayerModel<T>? in
                    if let index = chartPointModels.map({ $0.screenLoc.x }).findClosestElementIndexToValue(screenLoc.x) {
                        return chartPointModels[index]
                    } else {
                        return nil
                    }
            },
                  viewGenerator: { (chartPointModel, layer, chart) -> U? in
                    let containerView = U(frame: chart.contentView.bounds)

                    let xAxisOverlayView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 3 + containerView.frame.size.height), size: xAxisLayer.frame.size))
                    xAxisOverlayView.backgroundColor = UIColor.white
                    xAxisOverlayView.isOpaque = true
                    containerView.addSubview(xAxisOverlayView)
                    
                    let point = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 16)
                    point.fillColor = tintColor.withAlphaComponent(0.5)
                    containerView.addSubview(point)
                    
                    if let text = chartPointModel.chartPoint.y.labels.first?.text {
                        let label = UILabel()
                        if #available(iOS 9.0, *) {
                            label.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .bold)
                        } else {
                            label.font = UIFont.systemFont(ofSize: 15)
                        }
                        
                        label.text = text
                        label.textColor = tintColor
                        label.textAlignment = .center
                        label.sizeToFit()
                        label.frame.size.height += 4
                        label.frame.size.width += label.frame.size.height / 2
                        label.center.y = containerView.frame.origin.y
                        label.center.x = chartPointModel.screenLoc.x
                        label.frame.origin.x = min(max(label.frame.origin.x, containerView.frame.origin.x), containerView.frame.maxX - label.frame.size.width)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        label.layer.borderColor = tintColor.cgColor
                        label.layer.borderWidth = 1 / chart.view.traitCollection.displayScale
                        label.layer.cornerRadius = label.frame.size.height / 2
                        label.backgroundColor = UIColor.white
                        
                        containerView.addSubview(label)
                    }
                    
                    if let text = chartPointModel.chartPoint.x.labels.first?.text {
                        let label = UILabel()
                        label.font = axisLabelSettings.font
                        label.text = text
                        label.textColor = axisLabelSettings.fontColor
                        label.sizeToFit()
                        label.center = CGPoint(x: chartPointModel.screenLoc.x, y: xAxisOverlayView.center.y)
                        label.frame.origin.makeIntegralInPlaceWithDisplayScale(chart.view.traitCollection.displayScale)
                        
                        containerView.addSubview(label)
                    }
                    
                    return containerView
            }
        )
    }
}


private extension CGPoint {
    /**
     Rounds the coordinates to whole-pixel values

     - parameter scale: The display scale to use. Defaults to the main screen scale.
     */
    mutating func makeIntegralInPlaceWithDisplayScale(_ scale: CGFloat = 0) {
        var scale = scale

        // It's possible for scale values retrieved from traitCollection objects to be 0.
        if scale == 0 {
            scale = UIScreen.main.scale
        }
        x = round(x * scale) / scale
        y = round(y * scale) / scale
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Comparable, Index.Stride == Int {
    
    /**
     Returns the insertion index of a new value in a sorted collection

     Based on some helpful responses found at [StackOverflow](http://stackoverflow.com/a/33674192)

     - parameter value: The value to insert
     
     - returns: The appropriate insertion index, between `startIndex` and `endIndex`
     */
    func findInsertionIndexForValue(_ value: Iterator.Element) -> Index {
        var low = startIndex
        var high = endIndex

        while low != high {
            let mid = low.advanced(by: low.distance(to: high) / 2)
            
            if self[mid] < value {
                low = mid.advanced(by: 1)
            } else {
                high = mid
            }
        }

        return low
    }
}


private extension BidirectionalCollection where Index: Strideable, Iterator.Element: Strideable, Index.Stride == Int {
    /**
     Returns the index of the closest element to a specified value in a sorted collection

     - parameter value: The value to match

     - returns: The index of the closest element, or nil if the collection is empty
     */
    func findClosestElementIndexToValue(_ value: Iterator.Element) -> Index? {
        let upperBound = findInsertionIndexForValue(value)

        if upperBound == startIndex {
            if upperBound == endIndex {
                return nil
            }
            return upperBound
        }

        let lowerBound = upperBound.advanced(by: -1)

        if upperBound == endIndex {
            return lowerBound
        }

        if value.distance(to: self[upperBound]) < self[lowerBound].distance(to: value) {
            return upperBound
        }
        
        return lowerBound
    }
}
