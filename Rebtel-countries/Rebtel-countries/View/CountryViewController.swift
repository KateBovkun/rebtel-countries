//
//  CountryViewController.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-29.
//

import Foundation
import UIKit

final class CountryViewController: UIViewController {

    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bordersLabel: UILabel!
    @IBOutlet var bordersTableView: UITableView!
    @IBOutlet var tryAgainButton: UIButton!

    var countryViewModel: CountryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = countryViewModel.countryName
        bordersLabel.text = Strings.Country.borders.rawValue
        tryAgainButton.setTitle(Strings.Country.tryAgain.rawValue, for: .normal)
        loadFlagImage()
        self.bordersTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bordersTableView.indexPathsForSelectedRows?.forEach {
            bordersTableView.deselectRow(at: $0, animated: false)
        }
    }

    private func loadFlagImage() {
        flagImageView.image = nil
        Task { @MainActor in
            do {
                flagImageView.image = try await countryViewModel.countryFlag()
            } catch {
                flagImageView.image = nil
            }
        }
    }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, segue.identifier == "NextCountry" {
            let nextCountryViewModel: CountryViewModel = (try? countryViewModel.countryViewModel(at: cell.tag)) ?? countryViewModel
            (segue.destination as? CountryViewController)?.countryViewModel = nextCountryViewModel
        }
    }

    @IBAction func tryAgain() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension CountryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryViewModel.bordersCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = try? countryViewModel.borderName(at: indexPath.row)
        cell.tag = indexPath.row
        return cell
    }
}
