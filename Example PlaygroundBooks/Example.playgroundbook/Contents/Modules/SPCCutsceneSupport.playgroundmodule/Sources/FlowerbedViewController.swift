//
//  FlowerbedViewController.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(FlowerbedViewController)
public class FlowerbedViewController: UIViewController {

    @IBOutlet weak var hole00: HoleView!
    @IBOutlet weak var flower00: FlowerView!
    @IBOutlet weak var seed00: SeedView!

    @IBOutlet weak var hole10: HoleView!
    @IBOutlet weak var flower10: FlowerView!
    @IBOutlet weak var seed10: SeedView!

    @IBOutlet weak var hole20: HoleView!
    @IBOutlet weak var flower20: FlowerView!
    @IBOutlet weak var seed20: SeedView!

    @IBOutlet weak var hole30: HoleView!
    @IBOutlet weak var flower30: FlowerView!
    @IBOutlet weak var seed30: SeedView!

    @IBOutlet weak var hole01: HoleView!
    @IBOutlet weak var flower01: FlowerView!
    @IBOutlet weak var seed01: SeedView!

    @IBOutlet weak var hole11: HoleView!
    @IBOutlet weak var flower11: FlowerView!
    @IBOutlet weak var seed11: SeedView!

    @IBOutlet weak var hole21: HoleView!
    @IBOutlet weak var flower21: FlowerView!
    @IBOutlet weak var seed21: SeedView!

    @IBOutlet weak var hole31: HoleView!
    @IBOutlet weak var flower31: FlowerView!
    @IBOutlet weak var seed31: SeedView!

    @IBOutlet weak var hole02: HoleView!
    @IBOutlet weak var flower02: FlowerView!
    @IBOutlet weak var seed02: SeedView!

    @IBOutlet weak var hole12: HoleView!
    @IBOutlet weak var flower12: FlowerView!
    @IBOutlet weak var seed12: SeedView!

    @IBOutlet weak var hole22: HoleView!
    @IBOutlet weak var flower22: FlowerView!
    @IBOutlet weak var seed22: SeedView!

    @IBOutlet weak var hole32: HoleView!
    @IBOutlet weak var flower32: FlowerView!
    @IBOutlet weak var seed32: SeedView!

    // MARK:-

    public override func viewDidLoad() {
        super.viewDidLoad()

        holes = [
            [ hole00, hole01, hole02 ],
            [ hole10, hole11, hole12 ],
            [ hole20, hole21, hole22 ],
            [ hole30, hole31, hole32 ]
        ]

        seeds = [
            [ seed00, seed01, seed02 ],
            [ seed10, seed11, seed12 ],
            [ seed20, seed21, seed22 ],
            [ seed30, seed31, seed32 ]
        ]

        flowers = [
            [ flower00, flower01, flower02 ],
            [ flower10, flower11, flower12 ],
            [ flower20, flower21, flower22 ],
            [ flower30, flower31, flower32 ]
        ]
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Seeds are always invisible at the start of the scene.
        for row in seeds {
            for seed in row {
                seed.shrinkToInvisible()
            }
        }
    }

    // MARK:-

    /// Provides access to a specific animatable object in the flowerbed.
    ///
    /// - Parameter row: Zero-indexed value specifying the row of the object.
    /// - Parameter column: Zero-indexed value specifying the column of the object.
    ///
    /// - Returns: The object at the specified location, or nil, if there is no object at that location.

    public func hole(row: Int, column: Int) -> HoleView? {

        return getObject(rowIndex: row, columnIndex: column, from: holes)
    }

    /// Provides access to a specific animatable object in the flowerbed.
    ///
    /// - Parameter row: Zero-indexed value specifying the row of the object.
    /// - Parameter column: Zero-indexed value specifying the column of the object.
    ///
    /// - Returns: The object at the specified location, or nil, if there is no object at that location.

    public func flower(row: Int, column: Int) -> FlowerView? {

        return getObject(rowIndex: row, columnIndex: column, from: flowers)
    }

    /// Provides access to a specific animatable object in the flowerbed.
    ///
    /// - Parameter row: Zero-indexed value specifying the row of the object.
    /// - Parameter column: Zero-indexed value specifying the column of the object.
    ///
    /// - Returns: The object at the specified location, or nil, if there is no object at that location.

    public func seed(row: Int, column: Int) -> SeedView? {

        return getObject(rowIndex: row, columnIndex: column, from: seeds)
    }

    // MARK:- Private

    private var holes: [[HoleView]] = []
    private var seeds: [[SeedView]] = []
    private var flowers: [[FlowerView]] = []

    private func getObject<T>(rowIndex: Int, columnIndex: Int, from array: [[T]] ) -> T? {

        guard  rowIndex >= 0, rowIndex < array.count
            else { return nil }

        let row = array[rowIndex]
        guard columnIndex >= 0, columnIndex < row.count
            else { return nil }

        return row[columnIndex]
    }
}
